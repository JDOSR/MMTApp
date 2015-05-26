//
//  MMDevice.h
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *uuid;
extern NSString *kUUIDKey;
extern NSString *kUUIDMajorKey;
extern NSString *kUUIDMinorKey;

static NSString * const kVCLaunchDisplayForLocatedBeacon = @"kVCLaunchDisplayForLocatedBeacon";

@interface MMDevice : NSObject

@property (nonatomic, strong, readonly) NSArray *supportedUUIDs;

+ (MMDevice *)sharedInstance;
@end
