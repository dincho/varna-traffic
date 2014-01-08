//
//  MapViewController.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/30/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "MapViewController.h"
#import "VarnaTrafficDataSource.h"
#import "Device.h"
#import "Station.h"



@interface MapViewController ()


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MapViewController

@synthesize selectedAnnotation, searchBar, filteredArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.dataSource = [[VarnaTrafficDataSource alloc] init];
    self.filteredArray = [NSArray array];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    //set to Varna
    MKCoordinateRegion mapRegion;
    mapRegion.center.latitude = 43.20466;
    mapRegion.center.longitude = 27.910552;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;
    
    [self.mapView setRegion:mapRegion animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;
    
    [mapView setRegion:mapRegion animated:YES];
}

-(void)mapView:(OCMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"new region span: %f, %f", mapView.region.span.latitudeDelta, mapView.region.span.latitudeDelta);
    if (mapView.region.span.latitudeDelta < 0.02) {
        mapView.clusteringEnabled = NO;
    } else {
        mapView.clusteringEnabled = YES;
    }
    
    [self.mapView doClustering];
    
    if ([self.mapView.annotations containsObject:self.selectedAnnotation]) {
        [self.mapView selectAnnotation:self.selectedAnnotation animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // if it's a cluster
    if ([annotation isKindOfClass:[OCAnnotation class]]) {
        // create your custom cluster annotationView here!
        
        OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;
        
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ClusterView"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusterView"];
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(0, -100);
            annotationView.image = [UIImage imageNamed:@"busstop.png"];
        }
        
        // set title
        clusterAnnotation.title = @"Zoom in";
        clusterAnnotation.subtitle = [NSString stringWithFormat:@"Bus stops: %ld", [clusterAnnotation.annotationsInCluster count]];
        
        return annotationView;
    }
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[Station class]]) {
        // Try to dequeue an existing pin view first.
        MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"BusStopPinAnnotationView"];
        if (pinView) {
            pinView.annotation = annotation;
            return pinView;
        }
        
        
        // If an existing pin view was not available, create one.
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BusStopPinAnnotationView"];
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"busstop.png"];
        
        // Add a detail disclosure button to the callout.
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return pinView;
    }
    
    if ([annotation isKindOfClass:[Device class]]) {
        // Try to dequeue an existing pin view first.
        MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"DevicePinAnnotationView"];
        if (pinView) {
            pinView.annotation = annotation;
            return pinView;
        }
        
        // If an existing pin view was not available, create one.
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DevicePinAnnotationView"];
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"bus"];

        return pinView;
    }
    
    //not supported
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnotationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    id<MKAnnotation> annotation = [self.filteredArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = annotation.title;
    
    return cell;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
    
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AnnotationCell"];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
