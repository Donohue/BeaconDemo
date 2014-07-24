//
//  AppDelegate.m
//  BeaconDemo
//
//  Created by Brian Donohue on 7/23/14.
//  Copyright (c) 2014 Brian Donohue. All rights reserved.
//

#import "AppDelegate.h"
#import "BeaconTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BeaconTableViewController *bc = [[BeaconTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:bc];
    self.window.rootViewController = nc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
