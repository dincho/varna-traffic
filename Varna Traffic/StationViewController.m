//
//  StationViewController.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 1/2/14.
//  Copyright (c) 2014 Dincho Todorov. All rights reserved.
//

#import "StationViewController.h"

@interface StationViewController ()

@property (nonatomic, strong) NSArray *devices;
@property (nonatomic, strong) NSTimer *updateTimer;

- (void)updateDevices;

@end

@implementation StationViewController

@synthesize dataSource, station, delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = station.title;
    
    [self.dataSource loadStationDevicesWithID:self.station completionBLock:^(NSArray *newDevices) {
        self.devices = newDevices;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                        target:self
                                                      selector:@selector(updateDevices)
                                                      userInfo:nil
                                                       repeats:YES
                        ];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.updateTimer invalidate];
}

- (void)updateDevices
{
    [self.dataSource loadStationDevicesWithID:self.station completionBLock:^(NSArray *newDevices) {
        self.devices = newDevices;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeviceDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Device *device = [self.devices objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Line #%@", device.line];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"arrive time: %@ (%@); arrive in: %@ (%@)",
                                 device.arriveTime, device.delay, device.arriveIn, device.distanceLeft];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *device = [self.devices objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stationViewController:didSelectDevice:)]) {
        [self.delegate stationViewController:self didSelectDevice:device];
    }
}


@end
