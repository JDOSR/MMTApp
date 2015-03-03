//
//  MMTLocationManager.h
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import CoreLocation;

#import "MMTViewController.h"

@interface MMTLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (nonatomic, strong) NSTimer               *locationTimer;
@property (nonatomic, strong) CLLocation            *currentLocation;
@property (nonatomic, strong) NSMutableDictionary   *rangedBeacons;
@property (nonatomic, strong) NSArray               *proximityArray;
@property (nonatomic, strong) UIAlertController     *alertController;

@property (nonatomic, strong) NSMutableDictionary   *beacons;
@property (nonatomic, strong) MMTViewController     *viewController;

+ (MMTLocationManager *)sharedInstance;

- (void)startRangingForBeacons;
- (void)stopRangingForBeacons;

@end
