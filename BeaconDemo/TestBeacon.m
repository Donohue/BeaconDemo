//
//  TestBeacon.m
//  BeaconDemo
//
//  Created by Brian Donohue on 7/24/14.
//  Copyright (c) 2014 Brian Donohue. All rights reserved.
//

#import "TestBeacon.h"

@implementation TestBeacon

- (NSNumber *)major {
    return @(1234);
}

- (NSNumber *)minor {
    return @(4321);
}

- (NSUUID *)proximityUUID {
    return [[NSUUID alloc] initWithUUIDString:@"2C5FBF74-317E-417B-BDC6-5EE03FB41BB8"];
}

@end
