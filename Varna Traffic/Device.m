//
//  Device.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/29/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize id, line, arriveTime, delay, arriveIn, distanceLeft, coordinate;

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.id = [dict objectForKey:@"device"];
        self.line = [dict objectForKey:@"line"];
        self.arriveTime = [dict objectForKey:@"arriveTime"];
        self.delay = [dict objectForKey:@"delay"];
        self.arriveIn = [dict objectForKey:@"arriveIn"];
        self.distanceLeft = [dict objectForKey:@"distanceLeft"];
        
        coordinate.latitude = [[[dict objectForKey:@"position"] objectForKey:@"lat"] doubleValue];
        coordinate.longitude = [[[dict objectForKey:@"position"] objectForKey:@"lon"] doubleValue];
    }
    
    return self;
}

- (NSString *)title {
    return [NSString stringWithFormat:@"#%@", self.line];
}

@end
