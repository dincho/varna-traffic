//
//  StationsMapViewController.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/1/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StationsViewController.h"
#import "OCMapView.h"

@interface StationsMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSObject<TrafficDataSource> *dataSource;
@property (weak, nonatomic) IBOutlet OCMapView *mapView;

@end
