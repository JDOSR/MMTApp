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

@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (nonatomic, strong) NSTimer               *locationTimer;
@property (nonatomic, strong) CLLocation            *currentLocation;
@property (nonatomic, strong) NSMutableDictionary   *rangedBeacons;

+ (MMTLocationManager *)sharedInstance;

@end
