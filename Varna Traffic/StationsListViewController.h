//
//  StationsListViewController.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/1/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationsViewController.h"

@interface StationsListViewController : UITableViewController

@property (nonatomic, strong) NSObject<TrafficDataSource> *dataSource;


@end
