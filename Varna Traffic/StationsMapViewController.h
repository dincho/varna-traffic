//
//  StationsMapViewController.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/1/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "OCMapView.h"

@interface StationsMapViewController : MapViewController

@property (weak, nonatomic) IBOutlet OCMapView *mapView;

@end
