//
//  Device.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/29/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize id, line, arriveTime, delay, arriveIn, distanceLeft, stationId, nextStationId, coordinate;
@synthesize station, nextStation;

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.id = [dict objectForKey:@"device"];
        self.line = [dict objectForKey:@"line"];
        self.arriveTime = [dict objectForKey:@"arriveTime"];
        self.delay = [dict objectForKey:@"delay"];
        self.arriveIn = [dict objectForKey:@"arriveIn"];
        self.distanceLeft = [dict objectForKey:@"distanceLeft"];
        self.stationId = [dict objectForKey:@"stationId"];
        self.nextStationId = [dict objectForKey:@"nextStationId"];
        
        coordinate.latitude = [[[dict objectForKey:@"position"] objectForKey:@"lat"] doubleValue];
        coordinate.longitude = [[[dict objectForKey:@"position"] objectForKey:@"lon"] doubleValue];
    }
    
    return self;
}

- (NSString *)title
{
    if (self.nextStation) {
        return [NSString stringWithFormat:@"%@", self.nextStation.title];
    } else if (self.line) {
        return [NSString stringWithFormat:@"#%@", self.line];
    } else {
        return nil;
    }
}

- (NSString *)subtitle
{
    NSString *subtitle = [NSString stringWithFormat:@"%@ (%@)", self.arriveTime, self.delay];
    
    if (self.arriveIn) {
        subtitle = [NSString stringWithFormat:@"%@, след: %@", subtitle, self.arriveIn];
    }
    
    return subtitle;
}

@end
