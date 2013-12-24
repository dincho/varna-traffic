//
//  StationsMapViewController.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/1/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "StationsMapViewController.h"
#import "OCAnnotation.h"

static CGFloat kDEFAULTCLUSTERSIZE = 0.07;

@interface StationsMapViewController ()

-(void)showDetailsView:(UIButton *)sender;

@end

@implementation StationsMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	// Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.mapView.clusterSize = kDEFAULTCLUSTERSIZE;

    //set to Varna
    MKCoordinateRegion mapRegion;
    mapRegion.center.latitude = 43.20466;
    mapRegion.center.longitude = 27.910552;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;

    [self.mapView setRegion:mapRegion animated:NO];

    [self.dataSource loadStations:^(NSArray *stations) {
	[self.mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:stations waitUntilDone:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
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
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // if it's a cluster
    if ([annotation isKindOfClass:[OCAnnotation class]]) {
	// create your custom cluster annotationView here!

	OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;

	MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ClusterView"];
	if (!annotationView) {
	    annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusterView"];
	    annotationView.canShowCallout = YES;
	    annotationView.centerOffset = CGPointMake(0, -20);
	    annotationView.image = [UIImage imageNamed:@"busstop.png"];
	}

	//calculate cluster region
	CLLocationDistance clusterRadius = self.mapView.region.span.longitudeDelta * self.mapView.clusterSize * 111000 / 2.0f; //static circle size of cluster
	//CLLocationDistance clusterRadius = self.mapView.region.span.longitudeDelta/log(self.mapView.region.span.longitudeDelta*self.mapView.region.span.longitudeDelta) * log(pow([clusterAnnotation.annotationsInCluster count], 4)) * self.mapView.clusterSize * 50000; //circle size based on number of annotations in cluster

	MKCircle *circle = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
	[circle setTitle:@"background"];
	[self.mapView addOverlay:circle];

	MKCircle *circleLine = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
	[circleLine setTitle:@"line"];
	[self.mapView addOverlay:circleLine];

	// set title
	clusterAnnotation.title = @"Zoom in";
	clusterAnnotation.subtitle = [NSString stringWithFormat:@"Bus stops: %d", [clusterAnnotation.annotationsInCluster count]];

	return annotationView;
    }

    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
	return nil;
    }

    // Try to dequeue an existing pin view first.
    MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"BusStopPinAnnotationView"];
    if (pinView) {
	pinView.annotation = annotation;
	return pinView;
    }


    // If an existing pin view was not available, create one.
    pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
					       reuseIdentifier:@"BusStopPinAnnotationView"];

    //pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    pinView.image = [UIImage imageNamed:@"busstop.png"];

    // Add a detail disclosure button to the callout.
    UIButton* rightButton = [UIButton buttonWithType:
			     UIButtonTypeDetailDisclosure];

    [rightButton addTarget:self action:@selector(showDetailsView:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = rightButton;

    return pinView;
}

-(void)showDetailsView:(UIButton *)sender
{

}

@end
