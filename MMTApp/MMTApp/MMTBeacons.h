//
//  MMTBeacons.h
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

@interface MMTBeacons : NSObject

@property (nonatomic, strong, readonly) NSArray *supportedUUIDs;

+ (MMTBeacons *)sharedInstance;
@end
