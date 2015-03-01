//
//  MMTLocationManager.m
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMTLocationManager.h"
#import "MMTBeacons.h"

@interface MMTLocationManager()

@end

@implementation MMTLocationManager


- (id)init {
    self = [super init];
    if(self) {
        self.rangedBeacons = [[NSMutableDictionary alloc] init];
        [self setupBeacons];
    }
    return self;
}


+ (MMTLocationManager *)sharedInstance {
    static MMTLocationManager *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return(instance);
}

- (void)setupBeacons {
        [[MMTBeacons sharedInstance].supportedUUIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *beacon = (NSDictionary*)obj;
                NSUUID *uuid = (NSUUID *)[beacon objectForKey:kUUIDKey];
                CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                                 major:(UInt16)[beacon objectForKey:kUUIDMajorKey]
                                                                                 minor:(UInt16)[beacon objectForKey:kUUIDMinorKey]
                                                                            identifier:[uuid UUIDString]];
                self.rangedBeacons[region] = [NSArray array];
            }
        }];
    
}


- (void)startListeningForLocation {

    if(![self.locationTimer isValid]) {
        self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                              target:self
                                                            selector:@selector(stopListeningForLocation)
                                                            userInfo:nil
                                                             repeats:NO];
    }
    
    if(!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    @synchronized(self.locationManager) {
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
}


- (void)stopListeningForLocation {
    @synchronized(self.locationManager) {
        [self.locationManager stopUpdatingLocation];
        if([self.locationManager.monitoredRegions count] == 0) {
            [self.locationManager setDelegate:nil];
        }
    }
    [self.locationTimer invalidate];
}

#pragma mark - Location Manager Delegates

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {}
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {}


@end
