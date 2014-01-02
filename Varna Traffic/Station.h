//
//  Station.h
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/22/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Station : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
