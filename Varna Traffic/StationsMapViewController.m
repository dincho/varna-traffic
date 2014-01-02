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

- (void)updateDevices;
- (void)showDetailsView:(UIButton *)sender;
- (void)removeDeviceAnnotations;
- (void)filterContentForSearchText:(NSString*)searchText;

@end


@implementation StationsMapViewController

@synthesize stations;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.mapView.clusterSize = kDEFAULTCLUSTERSIZE;
    
    [self.dataSource loadStations:^(NSArray *newStations) {
        self.stations = newStations;
        [self.mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:newStations waitUntilDone:NO];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(updateDevices)
                                   userInfo:nil
                                    repeats:YES
    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //start showing devices for seleted station ID
    if ([view.annotation isKindOfClass:[Station class]]) {
        self.selectedAnnotation = view.annotation;
        [self updateDevices];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //stop showing devices for seleted station ID
}


-(void)showDetailsView:(UIButton *)sender
{

}

- (void)removeDeviceAnnotations
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [Device class]];
    NSArray *annotationsToRemove = [self.mapView.annotations filteredArrayUsingPredicate:predicate];
    [self.mapView removeAnnotations:annotationsToRemove];
}

- (void)updateDevices
{
    if (self.selectedAnnotation && [self.selectedAnnotation isKindOfClass:[Station class]]) {
        Station *station = (Station *)self.selectedAnnotation;
        [self.dataSource loadStationDevicesWithID:station.id completionBLock:^(NSArray *devices) {
            [self performSelectorOnMainThread:@selector(removeDeviceAnnotations) withObject:nil waitUntilDone:YES];
            [self.mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:devices waitUntilDone:NO];
        }];
    }
}


#pragma mark Content Filtering

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
    [self.mapView setRegion:mapRegion animated:YES];
}

@end
