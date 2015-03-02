//
//  MMTLocationManager.h
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MMTViewController.h"

@interface MMTLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableDictionary   *beacons;
@property (nonatomic, strong) MMTViewController     *viewController;

+ (MMTLocationManager *)sharedInstance;
- (void)startRanging;
- (void)stopRanging;
@end
