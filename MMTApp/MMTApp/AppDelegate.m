//
//  AppDelegate.m
//  MMTApp
//
//  Created by jasonowens on 2/27/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MMTLocationManager sharedInstance];
    [MMTNetworkManager sharedInstance];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[MMTLocationManager sharedInstance] stopRangingForBeacons];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[MMTLocationManager sharedInstance] stopRangingForBeacons];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[MMTLocationManager sharedInstance] startRangingForBeacons];

}
@end
