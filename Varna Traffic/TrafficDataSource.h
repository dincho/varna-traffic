//
//  TrafficDataSource.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/30/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TrafficDataSource <NSObject>

- (void)loadStations:(void (^)(NSArray *stations))completionBlock;
- (void)loadStationDevicesWithID:(NSString *)stationID completionBLock:(void (^)(NSArray *devices))completionBlock;
- (void)loadLineWithID:(NSString *)lineID completionBLock:(void (^)(NSDictionary *result))completionBlock;

@end
