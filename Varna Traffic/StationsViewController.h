//
//  StationsViewController.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/1/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrafficDataSource <NSObject>

- (void)loadStations:(void (^)(NSArray *stations))completionBlock;
- (NSArray *)stations;
- (NSArray *)stationDevicesWithID:(NSNumber *)stationID;
- (NSArray *)lineWithID:(NSString *)lineID;

@end

@interface StationsViewController : UIViewController <TrafficDataSource>

@property (strong, nonatomic) NSArray *stations;

- (void)switchToContentViewController:(UIViewController *)vc;

@end
