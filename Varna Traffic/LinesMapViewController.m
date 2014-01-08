//
//  LinesMapViewController.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/30/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "LinesMapViewController.h"
#import "Device.h"

@interface LinesMapViewController ()

@property (nonatomic, strong) NSArray *lines;
@property (nonatomic, strong) NSString *selectedLine;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, assign) BOOL shouldUpdateStations;

- (void)update;
- (void)dataLoaded:(NSDictionary *)result;

@end

@implementation LinesMapViewController

@synthesize lines;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.lines = [NSArray arrayWithObjects:@"7", @"10", @"13", @"18", @"29", @"31", @"39",
                  @"118", @"131", @"148", @"209", @"409", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.shouldUpdateStations = YES;
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                        target:self
                                                      selector:@selector(update)
                                                      userInfo:nil
                                                       repeats:YES
                        ];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.updateTimer invalidate];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //don't call super, we don't cluster
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.selectedAnnotation = view.annotation;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [super mapView:mapView viewForAnnotation:annotation];
    annotationView.rightCalloutAccessoryView = nil;
    
    return annotationView;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnotationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *line = [self.filteredArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = line;
    
    return cell;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
    self.filteredArray = [self.lines filteredArrayUsingPredicate:predicate];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLine = [self.filteredArray objectAtIndex:indexPath.row];
    [self.searchDisplayController setActive:NO animated:YES];
}

- (void)dataLoaded:(NSDictionary *)result
{
    if (self.shouldUpdateStations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotations:[result objectForKey:@"stations"]];
        self.shouldUpdateStations = NO; //updated.
    } else {
        //remove only devices
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [Device class]];
        NSArray *annotationsToRemove = [self.mapView.annotations filteredArrayUsingPredicate:predicate];
        [self.mapView removeAnnotations:annotationsToRemove];
    }
    
    [self.mapView addAnnotations:[result objectForKey:@"devices"]];
    
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

- (void)update
{
    if (!self.selectedLine) {
        return;
    }
    
    [self.dataSource loadLineWithID:self.selectedLine completionBLock:^(NSDictionary *result) {        
        [self performSelectorOnMainThread:@selector(dataLoaded:) withObject:result waitUntilDone:NO];
    }];
}

@end
