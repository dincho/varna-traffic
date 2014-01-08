//
//  StationViewController.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 1/2/14.
//  Copyright (c) 2014 Dincho Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficDataSource.h"
#import "Station.h"
#import "Device.h"

@class StationViewController;

@protocol StationViewControllerDelegate <NSObject>

- (void)stationViewController:(StationViewController *)viewController didSelectDevice:(Device *)device;

@end

@interface StationViewController : UITableViewController

@property (nonatomic, strong) NSObject<TrafficDataSource> *dataSource;
@property (nonatomic, strong) Station *station;
@property (nonatomic, weak) id<StationViewControllerDelegate> delegate;

@end
