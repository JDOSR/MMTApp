//
//  MMTBeacons.m
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMTBeacons.h"

NSString *uuid = @"B7499731-06DF-4D2B-9525-C5C790C73D69";

NSString const *kUUIDKey = @"uuid";
NSString const *kUUIDMajorKey = @"major";
NSString const *kUUIDMinorKey = @"minor";

@implementation MMTBeacons


- (id)init {
    self = [super init];
    if(self) {
        _supportedUUIDs = @[@{kUUIDKey : [[NSUUID alloc] initWithUUIDString:uuid], kUUIDMajorKey : @1000, kUUIDMinorKey : @1},
                            @{kUUIDKey : [[NSUUID alloc] initWithUUIDString:uuid], kUUIDMajorKey : @1000, kUUIDMinorKey : @2},
                            @{kUUIDKey : [[NSUUID alloc] initWithUUIDString:uuid], kUUIDMajorKey : @1000, kUUIDMinorKey : @3}];
    }
    
    return self;
}


+ (MMTBeacons *)sharedInstance {
    static MMTBeacons *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return(instance);
}

@end
