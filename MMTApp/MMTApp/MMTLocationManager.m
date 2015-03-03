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
static int kSingleBeaconInArray = 1;

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
        self.rangedBeacons = [[NSMutableDictionary alloc] init];
        self.proximityArray = @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)];
        _alertController = nil;
        
        [self setupLocationManager];
        [self setupBeaconRegions];
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

- (void)setupBeaconRegions {
    NSArray *supportedBeacons = [MMDevice sharedInstance].supportedUUIDs;
    [supportedBeacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *beacon = (NSDictionary*)obj;
            NSUUID *uuid = (NSUUID *)[beacon objectForKey:kUUIDKey];
            NSNumber *major = (NSNumber *)[beacon objectForKey:kUUIDMajorKey];
            NSNumber *minor = (NSNumber *)[beacon objectForKey:kUUIDMinorKey];
            CLBeaconRegion *region;
            
            if(major && minor) {
                region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[major shortValue] minor:[minor shortValue] identifier:[uuid UUIDString]];
            } else if(major && !minor) {
                region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[major shortValue] identifier:[uuid UUIDString]];
            } else if(!major && !minor) {
                region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
            }
            
            self.rangedBeacons[region] = [NSArray array];
        }
    }];
}

- (void)startRangingForBeacons {
    
    @synchronized(self.locationManager) {
        [self.rangedBeacons enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([key isKindOfClass:[CLBeaconRegion class]]) {
                CLBeaconRegion *beaconRegion = (CLBeaconRegion*)key;
                [self.locationManager startRangingBeaconsInRegion:beaconRegion];
            }
        }];
    }
}

- (void)stopRangingForBeacons {
    @synchronized(self.locationManager) {
        [self.rangedBeacons enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([key isKindOfClass:[CLBeaconRegion class]]) {
                CLBeaconRegion *beaconRegion = (CLBeaconRegion*)key;
                [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
            }
        }];
    }
}


#pragma mark - Helper Methods
- (void)findClosetBeacon:(NSArray *)allBeacons inRange:(NSNumber *)range {
    CLBeacon *closestBeacon;
    NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:kCLProximityPredicateFormat, [range intValue]]];
    if([proximityBeacons count] > kSingleBeaconInArray) {
        NSSortDescriptor *closest = [[NSSortDescriptor alloc] initWithKey:kDeviceParameterKey ascending:YES];
        NSArray *sortedBeacons = [proximityBeacons sortedArrayUsingDescriptors:[NSArray arrayWithObject:closest]];
        closestBeacon = (CLBeacon *)[sortedBeacons firstObject];
    } else if ([proximityBeacons count] == kSingleBeaconInArray) {
        closestBeacon = (CLBeacon *)[proximityBeacons firstObject];
    }
    
    if (closestBeacon && ![self isCurrentBeacon:closestBeacon]) {
        self.beacons[range] = closestBeacon;
        _currentBeacon = closestBeacon;
        if(!self.viewController.alertController) {
            [self displayAlertController];
        }
    }
}

- (void)displayAlertController {
    [[NSNotificationCenter defaultCenter] postNotificationName:kVCLaunchDisplayForLocatedBeacon object:[_currentBeacon copy]];
}

- (BOOL)isCurrentBeacon:(CLBeacon *)closestBeacon {
    return [[closestBeacon.proximityUUID UUIDString] isEqualToString:[_currentBeacon.proximityUUID UUIDString]];
}

#pragma mark - LocationManager Delegates

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
            [self findClosetBeacon:allBeacons inRange:range];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"rangingBeaconsDidFailForRegion: %@", [error description]);
}


@end
