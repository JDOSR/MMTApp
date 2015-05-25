//
//  MMPlaylist.h
//  MMTApp
//
//  Created by Jason Owens on 5/24/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kMMPlaylistName;
extern NSString *kMMID;
extern NSString *kMMPlaylistTS;
extern NSString *kMMPlaylistSongs;

@interface MMPlaylist : NSObject
@property (nonatomic, strong) NSString          *playlistName;
@property (nonatomic, strong) NSString          *playlistID;
@property (nonatomic, strong) NSString          *time;
@property (nonatomic, strong) NSMutableArray    *songs;
@end
