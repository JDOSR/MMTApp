//
//  MMTLocationManager.m
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMTLocationManager.h"
#import "MMDevice.h"

static NSString * const kCLProximityPredicateFormat = @"(proximity = %d) AND (proximity >= 0)";
static NSString * const kDeviceParameterKey = @"accuracy";

@interface MMTLocationManager()
@property (nonatomic, strong) CLBeacon *currentBeacon;
@end

@implementation MMTLocationManager

+ (MMTLocationManager *)sharedInstance {
    static MMTLocationManager *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return(instance);
}

- (id)init {
    self = [super init];
    if(self) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
        self.rangedBeacon = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:0 minor:0 identifier:[uuid UUIDString]];
        self.rangedBeacons = [[NSMutableDictionary alloc] init];
        self.proximityArray = @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)];
        _alertController = nil;
        
        [self setupLocationManager];
    }
    return self;
}

- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
}

#pragma  mark - BEACON METHODS

- (void)startRangingForBeacons {
    @synchronized(self.locationManager) {
        [self.locationManager startRangingBeaconsInRegion:self.rangedBeacon];
    }
}

- (void)stopRangingForBeacons {
    @synchronized(self.locationManager) {
        [self.locationManager stopRangingBeaconsInRegion:self.rangedBeacon];
    }
}


#pragma mark - Helper Methods

- (BOOL)isCurrentBeacon:(CLBeacon *)closestBeacon {
    return [[closestBeacon.proximityUUID UUIDString] isEqualToString:[_currentBeacon.proximityUUID UUIDString]];
}

#pragma mark - LocationManager Delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    if([beacons count] < 1) return;
    [self stopRangingForBeacons];
    [[NSNotificationCenter defaultCenter] postNotificationName:kVCLaunchDisplayForLocatedBeacon object:[beacons firstObject]];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorized) {
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"rangingBeaconsDidFailForRegion: %@", [error description]);
}


@end
