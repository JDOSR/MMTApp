//
//  MMTLocationManager.h
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef enum {
    MMTLocationServiceStatusDisabled,
    MMTLocationServiceStatusAuthorized,
    MMTLocationServiceStatusRestricted,
    MMTLocationServiceStatusDenied,
    MMTLocationServiceStatusNotDetermined,
    MMTLocationServiceStatusAuthorizedAlways,
    MMTLocationServiceStatusAuthorizedWhenInUse,
} MMTLocationStatus;

@interface MMTLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableDictionary   *beacons;

+ (MMTLocationManager *)sharedInstance;
- (void)startRanging;
- (void)stopRanging;
@end
