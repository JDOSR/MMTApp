//
//  MMDevice.m
//  MMTApp
//
//  Created by jasonowens on 2/28/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMDevice.h"

NSString *uuid = @"B7499731-06DF-4D2B-9525-C5C790C73D69";

NSString *test1UUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
NSString *test2UUID = @"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5";

NSString const *kUUIDKey = @"uuid";
NSString const *kUUIDMajorKey = @"major";
NSString const *kUUIDMinorKey = @"minor";

@implementation MMDevice




- (id)init {
    self = [super init];
    if(self) {
        _supportedUUIDs = @[@{kUUIDKey : [[NSUUID alloc] initWithUUIDString:test1UUID], kUUIDMajorKey : @0, kUUIDMinorKey : @0}];
    }
    
    return self;
}


+ (MMDevice *)sharedInstance {
    static MMDevice *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return(instance);
}
@end
