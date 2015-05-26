//
//  MMTNetworkManager.h
//  MMTApp
//
//  Created by jasonowens on 3/1/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPlaylist.h"

static NSString * const kDataTaskCompletionNotificationDidFinishLoading = @"kDataTaskCompletionNotificationDidFinishLoading";

static NSString * const kMMDataPlaylistURL = @"https://onlinedj.moodmedia.com/api/v1/playlists/16405.json";
static NSString * const kMMPOSTUrl = @"https://onlinedj.moodmedia.com/api/v1/playlists/16405/votes.json";
//{ "song_id": 156558}

@interface MMTNetworkManager : NSObject
@property (nonatomic, retain) MMPlaylist *result;
+ (MMTNetworkManager *)sharedInstance;

- (void)buildURLRequests;
- (BOOL)postDataWithParams:(NSDictionary *)params;
@end
