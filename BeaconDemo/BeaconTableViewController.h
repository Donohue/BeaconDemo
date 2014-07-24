//
//  BeaconTableViewController.h
//  BeaconDemo
//
//  Created by Brian Donohue on 7/23/14.
//  Copyright (c) 2014 Brian Donohue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BeaconTableViewController : UITableViewController <CLLocationManagerDelegate, CBPeripheralManagerDelegate>

#define ESTIMOTE_PROXIMITY_UUID             [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]

@end
