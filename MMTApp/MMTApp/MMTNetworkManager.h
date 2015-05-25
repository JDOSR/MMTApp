//
//  MMTNetworkManager.h
//  MMTApp
//
//  Created by jasonowens on 3/1/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPlaylist.h"

@interface MMTNetworkManager : NSObject
@property (nonatomic, retain) MMPlaylist *result;
+ (MMTNetworkManager *)sharedInstance;

- (void)buildURLRequests;

@end
