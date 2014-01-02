//
//  Station.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/22/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "Station.h"

@implementation Station

@synthesize id, name, coordinate;

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
	self.id = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"text"];

	coordinate.latitude = [[[dict objectForKey:@"position"] objectForKey:@"lat"] doubleValue];
	coordinate.longitude = [[[dict objectForKey:@"position"] objectForKey:@"lon"] doubleValue];
    }

    return self;
}

- (NSString *)title {
    return name;
}

@end
