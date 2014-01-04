//
//  Device.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/29/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTAnnotation.h"
#import "Station.h"

@interface Device : VTAnnotation

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *line;
@property (strong, nonatomic) NSString *arriveTime;
@property (strong, nonatomic) NSString *delay;
@property (strong, nonatomic) NSString *arriveIn;
@property (strong, nonatomic) NSString *distanceLeft;
@property (strong, nonatomic) NSNumber *stationId;
@property (strong, nonatomic) NSNumber *nextStationId;
@property (strong, nonatomic) Station *station;
@property (strong, nonatomic) Station *nextStation;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
