//
//  MMAlbum.m
//  MMTApp
//
//  Created by jasonowens on 3/1/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMAlbum.h"

NSString const *kMMAlbum = @"album_name";
NSString const *kMMAlbumCoverArt = @"cover_art";
NSString const *kMMAlbumTitle = @"title";
NSString const *kMMSDuration = @"duration";
NSString const *kMMAlbumArtist = @"artist_name";
NSString const *kMMAlbumPosition = @"position";
NSString const *kMMAlbumDescription = @"description";
NSString const *kMMAlbumLastPlayed = @"last_play_date";
NSString const *kMMAlbumTrackID = @"id";


@interface MMAlbum()
@end

@implementation MMAlbum


- (id)init {
    if(self = [super init]) {
        
    }
    return self;
}

+(MMAlbum *)createAlbumFromDictionary:(NSDictionary *)json {

    MMAlbum *albumContent = [[MMAlbum alloc] init];
    if([json isKindOfClass:[NSDictionary class]]) {
        albumContent.trackId = [json objectForKey:kMMAlbumTrackID];
        albumContent.title = [json objectForKey:kMMAlbumTitle];
        albumContent.duration = [json objectForKey:kMMSDuration];
        albumContent.artist = [json objectForKey:kMMAlbumArtist];
        albumContent.album = [json objectForKey:kMMAlbum];
        albumContent.coverArtURL = [json objectForKey:kMMAlbumCoverArt];
        albumContent.position = [[json objectForKey:kMMAlbumPosition] integerValue];
        albumContent.albumDescription = [json objectForKey:kMMAlbumDescription];
        albumContent.last_play_date = [json objectForKey:kMMAlbumLastPlayed];
        //
        albumContent.coverArtImage = [[UIImageView alloc] init];
    }
    return albumContent;
    
}

@end
