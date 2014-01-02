//
//  LinesMapViewController.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/30/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "LinesMapViewController.h"

@interface LinesMapViewController ()

@property (nonatomic, strong) NSArray *lines;
@property (nonatomic, strong) NSString *selectedLine;

- (void)update;

@end

@implementation LinesMapViewController

@synthesize lines;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.lines = [NSArray arrayWithObjects:@"7", @"10", @"12", @"18", @"29", @"31", @"39",
                  @"118", @"131", @"148", @"209", @"409", nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(update)
                                   userInfo:nil
                                    repeats:YES
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //don't call super, we don't cluster
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.selectedAnnotation = view.annotation;
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

- (void)update
{
    if (!self.selectedLine) {
        return;
    }
    
    [self.dataSource loadLineWithID:self.selectedLine completionBLock:^(NSDictionary *result) {
        NSArray *stations = [result objectForKey:@"stations"];
        NSArray *devices = [result objectForKey:@"devices"];
        
        NSLog(@"stations: %@", stations);
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:stations waitUntilDone:NO];
        [self.mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:devices waitUntilDone:NO];
    }];
    
    if ([self.mapView.annotations containsObject:self.selectedAnnotation]) {
        [self.mapView selectAnnotation:self.selectedAnnotation animated:YES];
    }
    
    //    MKCoordinateRegion mapRegion;
    //    mapRegion.center = station.coordinate;
    //    mapRegion.span.latitudeDelta = 0.015;
    //    mapRegion.span.longitudeDelta = 0.015;
    //
    //    self.selectedAnnotation = station;
    //    [self.mapView setRegion:mapRegion animated:YES];
}

@end
