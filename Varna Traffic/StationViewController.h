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

@interface StationViewController : UITableViewController

@property (nonatomic, strong) NSObject<TrafficDataSource> *dataSource;
@property (nonatomic, strong) Station *station;

@end
