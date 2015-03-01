//
//  MMTNetworkManager.m
//  MMTApp
//
//  Created by jasonowens on 3/1/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMTNetworkManager.h"


static NSString * const kNMApiUrl = @"https://s3.amazonaws.com/ibeacon-mock/%@/%@/%@.json";

@interface MMTNetworkManager() <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
@end

@implementation MMTNetworkManager


- (id)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}





+ (MMTNetworkManager *)sharedInstance {
    static MMTNetworkManager *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return(instance);
}


@end
