//
//  MMTLocationManager.m
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMTLocationManager.h"
#import "MMTBeacons.h"

static NSString * const kCLProximityPredicateFormat = @"proximity = %d";
@interface MMTLocationManager()

@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (nonatomic, strong) NSTimer               *locationTimer;
@property (nonatomic, strong) CLLocation            *currentLocation;
@property (nonatomic, strong) NSMutableDictionary   *rangedBeacons;
@property (nonatomic, strong) NSArray               *proximityArray;


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
        self.rangedBeacons = [[NSMutableDictionary alloc] init];
        self.proximityArray = @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)];
        [self setupBeacons];
    }
    return self;
}



- (void)setupBeacons {
    MMTBeacons *supportedBeacons = [[MMTBeacons alloc] init];
    NSArray *beaconArray = supportedBeacons.supportedUUIDs;
    [beaconArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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


- (void)startRanging {

    if(![self.locationTimer isValid]) {
        self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                              target:self
                                                            selector:@selector(stopRanging)
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
        [self.rangedBeacons enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([obj isKindOfClass:[CLBeaconRegion class]]) {
                [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)obj];
            }
        }];
    }
}


- (void)stopRanging {
    @synchronized(self.locationManager) {
        [self.rangedBeacons enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([obj isKindOfClass:[CLBeaconRegion class]]) {
                [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)obj];
            }
        }];
    }
    [self.locationTimer invalidate];
}

#pragma mark - LocationManager Delegates

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {}
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    self.rangedBeacons[region] = beacons;
    [self.beacons removeAllObjects];
    
    NSMutableArray *allBeacons = [NSMutableArray array];
    [[self.rangedBeacons allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[NSArray class]]) {
            [allBeacons addObjectsFromArray:(NSArray *)obj];
        }
    }];
    
    [self.proximityArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *range = (NSNumber*)obj;
            NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:kCLProximityPredicateFormat, [range intValue]]];
            if([proximityBeacons count] > 0) {
                self.beacons[range] = proximityBeacons;
            }
        }
    }];
    
    
}


@end
