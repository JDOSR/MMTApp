//
//  MMTNetworkManager.h
//  MMTApp
//
//  Created by jasonowens on 3/1/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kDataTaskCompletionNotificationDidFinishLoading = @"kDataTaskCompletionNotificationDidFinishLoading";


@interface MMTNetworkManager : NSObject
@property (nonatomic, retain) NSMutableArray *results;
+ (MMTNetworkManager *)sharedInstance;
@end
