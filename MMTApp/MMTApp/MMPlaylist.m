//
//  MMPlaylist.m
//  MMTApp
//
//  Created by Jason Owens on 5/24/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMPlaylist.h"

NSString const *kMMPlaylistName = @"name";
NSString const *kMMID = @"id";
NSString const *kMMPlaylistTS = @"server_time";
NSString const *kMMPlaylistSongs = @"songs";


@implementation MMPlaylist

- (id)init {
    if(self = [super init]) {
        self.songs = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

@end
