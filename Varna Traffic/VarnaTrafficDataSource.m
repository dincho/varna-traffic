//
//  VarnaTrafficDataSource.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/30/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "VarnaTrafficDataSource.h"
#import "Station.h"
#import "Device.h"

@implementation VarnaTrafficDataSource

- (void)loadStations:(void (^)(NSArray *stations))completionBlock
{
    NSURL *url = [NSURL URLWithString:@"http://varnatraffic.com/Ajax/GetStations"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (nil != error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %ld", [error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSMutableArray *newStations = [NSMutableArray array];
        NSArray *stationsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *stationDict in stationsArray) {
            Station *station = [[Station alloc] initWithDictionary:stationDict];
            [newStations insertObject:station atIndex:[newStations count]];
        }
        
        completionBlock([NSArray arrayWithArray:newStations]);
    }];
}

- (void)loadStationDevicesWithID:(Station *)station completionBLock:(void (^)(NSArray *devices))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"http://varnatraffic.com/Ajax/FindStationDevices?stationId=%@", station.id];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (nil != error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %ld", [error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSMutableArray *newDevices = [NSMutableArray array];
        NSDictionary *devicesDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *deviceDict in [devicesDict objectForKey:@"liveData"]) {
            if ([deviceDict objectForKey:@"arriveIn"]) {
                Device *device = [[Device alloc] initWithDictionary:deviceDict];
                [newDevices insertObject:device atIndex:[newDevices count]];
            }
        }
        
        completionBlock([NSArray arrayWithArray:newDevices]);
    }];
    
    return;
}

- (void)loadLineWithID:(NSString *)lineID completionBLock:(void (^)(NSDictionary *result))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"http://varnatraffic.com/Ajax/GetLineState?line=%@", lineID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (nil != error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %ld", [error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSDictionary *lineDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *devices = [NSMutableArray array];
        [devices addObjectsFromArray:[[lineDict objectForKey:@"devices"] firstObject]];
        [devices addObjectsFromArray:[[lineDict objectForKey:@"devices"] lastObject]];
        
        NSMutableArray *newDevices = [NSMutableArray array];
        for (NSDictionary *deviceDict in devices) {
            Device *device = [[Device alloc] initWithDictionary:deviceDict];
            [newDevices insertObject:device atIndex:[newDevices count]];
        }
        
        NSMutableArray *stations = [NSMutableArray array];
        [stations addObjectsFromArray:[[lineDict objectForKey:@"stations"] firstObject]];
        [stations addObjectsFromArray:[[lineDict objectForKey:@"stations"] lastObject]];
        
        NSMutableArray *newStations = [NSMutableArray array];
        for (NSDictionary *stationDict in stations) {
            Station *station = [[Station alloc] initWithDictionary:stationDict];
            [newStations insertObject:station atIndex:[newStations count]];
        }
        
        //map stations to devices
        NSPredicate *predicate;
        NSArray *stationsFound;
        for (Device *device in newDevices) {
            predicate = [NSPredicate predicateWithFormat:@"id == %@", device.nextStationId];
            stationsFound = [newStations filteredArrayUsingPredicate:predicate];
            device.nextStation = [stationsFound firstObject];

            predicate = [NSPredicate predicateWithFormat:@"id == %@", device.stationId];
            stationsFound = [newStations filteredArrayUsingPredicate:predicate];
            device.station = [stationsFound firstObject];
        }
        
        NSDictionary *result = @{
            @"devices": newDevices,
            @"stations": newStations
        };
        
        completionBlock(result);
    }];
    
    return;
}

@end
