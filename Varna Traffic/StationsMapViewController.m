//
//  StationsMapViewController.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/1/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "StationsMapViewController.h"
#import "VarnaTrafficDataSource.h"
#import "OCAnnotation.h"
#import "Station.h"
#import "Device.h"

static CGFloat kDEFAULTCLUSTERSIZE = 0.07;

@interface StationsMapViewController ()

@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) Station *selectedStation;
@property (nonatomic, strong) NSTimer *updateTimer;

- (void)updateAnnotations:(NSArray *)annotations;
- (void)updateDevices;
- (void)filterContentForSearchText:(NSString*)searchText;
- (void)startUpdating;
- (void)stopUpdating;

@end


@implementation StationsMapViewController

@synthesize stations;

#pragma mark - UIViewController overwrites

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.mapView.clusterSize = kDEFAULTCLUSTERSIZE;
    self.mapView.minLongitudeDeltaToCluster = 0.02;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.dataSource loadStations:^(NSArray *newStations) {
        self.stations = newStations;
        [self.mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:newStations waitUntilDone:NO];
    }];
    
    [self startUpdating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopUpdating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentStationViewController"]) {
        StationViewController *svc = (StationViewController *)[segue destinationViewController];
        MKAnnotationView *annoView = (MKAnnotationView *)sender;
        svc.station = annoView.annotation;
        svc.dataSource = self.dataSource;
        svc.delegate = self;
    }
}

#pragma mark - MKMapViewDelegate protocol

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[Station class]]) {
        [self performSegueWithIdentifier:@"presentStationViewController" sender:view];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.selectedAnnotation = view.annotation;
    
    //start showing devices for seleted station ID
    if ([view.annotation isKindOfClass:[Station class]]) {
        self.selectedStation = view.annotation;
        [self startUpdating];
    } else if([view.annotation isKindOfClass:[OCAnnotation class]]) {
        [self stopUpdating];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //stop showing devices for seleted station ID
}

#pragma mark - Instance Methods

- (void)startUpdating
{
    if (nil != self.updateTimer) {
        [self.updateTimer invalidate];
    }
    
    [self updateDevices];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                        target:self
                                                      selector:@selector(updateDevices)
                                                      userInfo:nil
                                                       repeats:YES
                        ];
}

- (void)stopUpdating
{
    if (nil != self.updateTimer) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
}

- (void)updateAnnotations:(NSArray *)annotations
{
    //remove device annotations
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [Device class]];
    NSArray *annotationsToRemove = [self.mapView.annotations filteredArrayUsingPredicate:predicate];
    [self.mapView removeAnnotations:annotationsToRemove];
    
    //don't cluster devices
    self.mapView.annotationsToIgnore = [NSMutableSet setWithArray:annotations];
    
    //add new annotations
    [self.mapView addAnnotations:annotations];
    
    if ([self.selectedAnnotation isKindOfClass:[Device class]]) {
        Device *selectedDevice = (Device *) self.selectedAnnotation;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@ AND id == %@", [VTAnnotation class], selectedDevice.id];
        NSArray *foundAnnotations = [self.mapView.annotations filteredArrayUsingPredicate:predicate];
        if ([foundAnnotations count] > 0) {
            [self.mapView selectAnnotation:[foundAnnotations firstObject] animated:NO];
        }
    } else {
        if ([self.mapView.annotations containsObject:self.selectedAnnotation]) {
            [self.mapView selectAnnotation:self.selectedAnnotation animated:YES];
        }
    }
}

- (void)updateDevices
{
    if (self.selectedStation) {
        [self.dataSource loadStationDevicesWithID:self.selectedStation completionBLock:^(NSArray *devices) {
            [self performSelectorOnMainThread:@selector(updateAnnotations:) withObject:devices waitUntilDone:NO];
        }];
    }
}


#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    self.filteredArray = [self.stations filteredArrayUsingPredicate:predicate];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Station *station = [self.filteredArray objectAtIndex:indexPath.row];
    
    [self.searchDisplayController setActive:NO animated:YES];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = station.coordinate;
    mapRegion.span.latitudeDelta = 0.015;
    mapRegion.span.longitudeDelta = 0.015;
    
    self.selectedAnnotation = station;
    self.selectedStation = station;
    [self.mapView setRegion:mapRegion animated:YES];
}

#pragma mark - StationViewControllerDelegate Protocol Conforming

- (void)stationViewController:(StationViewController *)viewController didSelectDevice:(Device *)device
{
    self.selectedAnnotation = device;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
