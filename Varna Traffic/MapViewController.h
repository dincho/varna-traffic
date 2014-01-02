//
//  MapViewController.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/30/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrafficDataSource.h"
#import "OCMapView.h"

@interface MapViewController : UIViewController
    <MKMapViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet OCMapView *mapView;
@property (nonatomic, strong) id<MKAnnotation> selectedAnnotation;
@property (nonatomic, strong) NSObject<TrafficDataSource> *dataSource;
@property (nonatomic, strong) NSArray *filteredArray;

@end
