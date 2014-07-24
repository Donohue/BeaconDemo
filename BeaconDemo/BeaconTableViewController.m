//
//  BeaconTableViewController.m
//  BeaconDemo
//
//  Created by Brian Donohue on 7/23/14.
//  Copyright (c) 2014 Brian Donohue. All rights reserved.
//

#import "BeaconTableViewController.h"
#import "TestBeacon.h"

@interface BeaconTableViewController ()

@property (nonatomic, strong) NSMutableArray *nearbyBeacons;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@end

@implementation BeaconTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _nearbyBeacons = [[NSMutableArray alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        NSString *identifier = [NSString stringWithFormat:@"com.bthdonohue.BeaconDemo.%@", ESTIMOTE_PROXIMITY_UUID];
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                    identifier:identifier];
        [_locationManager startRangingBeaconsInRegion:region];
        
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        
#if TARGET_IPHONE_SIMULATOR
        TestBeacon *beacon = [[TestBeacon alloc] init];
        [self locationManager:_locationManager
              didRangeBeacons:@[beacon]
                     inRegion:nil];
#endif
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Beacon Demo";
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"2C5FBF74-317E-417B-BDC6-5EE03FB41BB8"];
        int major = 1234;
        int minor = 4321;
        NSString *identifier = [NSString stringWithFormat:@"com.bthdonohue.BeaconDemo.%@.%d.%d",
                                uuid, major, minor];
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                         major:major
                                                                         minor:minor
                                                                    identifier:identifier];
        NSDictionary *data = [region peripheralDataWithMeasuredPower:nil];
        [_peripheralManager startAdvertising:data];
    }
}

- (BOOL)beaconIsInArray:(CLBeacon *)beacon {
    for (CLBeacon *nearbyBeacon in _nearbyBeacons) {
        if ([beacon.proximityUUID isEqual:nearbyBeacon.proximityUUID] &&
            beacon.major.integerValue == nearbyBeacon.major.integerValue &&
            beacon.minor.integerValue == nearbyBeacon.minor.integerValue)
            return YES;
    }
    
    return NO;
}

- (NSInteger)indexOfBeaconForRegion:(CLBeaconRegion *)region {
    int i;
    for (i = 0; i < [_nearbyBeacons count]; i++) {
        CLBeacon *beacon = [_nearbyBeacons objectAtIndex:i];
        if ([beacon.proximityUUID isEqual:region.proximityUUID] &&
            beacon.major.integerValue == region.major.integerValue &&
            beacon.minor.integerValue == region.minor.integerValue)
            break;
    }
    
    if (i == [_nearbyBeacons count])
        return NSNotFound;
    return i;
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        if (![self beaconIsInArray:beacon]) {
            [_nearbyBeacons addObject:beacon];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_nearbyBeacons count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            NSString *identifier = [NSString stringWithFormat:@"com.bthdonohue.BeaconDemo.%@.%@.%@",
                                    ESTIMOTE_PROXIMITY_UUID, beacon.major, beacon.minor];
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.proximityUUID
                                                                             major:beacon.major.integerValue minor:beacon.minor.integerValue identifier:identifier];
            [_locationManager startMonitoringForRegion:region];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered region");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    int index = [self indexOfBeaconForRegion:(CLBeaconRegion *)region];
    if (index != NSNotFound) {
        [_nearbyBeacons removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_nearbyBeacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    CLBeacon *beacon = [_nearbyBeacons objectAtIndex:indexPath.row];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:reuseIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@",
                           beacon.major, beacon.minor];
    return cell;
}
 
@end
