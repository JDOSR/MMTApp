//
//  MMAlbum.m
//  MMTApp
//
//  Created by jasonowens on 3/1/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMAlbum.h"

NSString const *kMMAlbum = @"album";
NSString const *kMMAlbumCoverArt = @"cover_art";
NSString const *kMMAlbumTitle = @"title";
NSString const *kMMAlbumArtist = @"artist";
NSString const *kMMAlbumMajor = @"major";
NSString const *kMMAlbumMinor = @"minor";
NSString const *kMMAlbumTrack = @"track";
NSString const *kMMAlbumUUID = @"uuid";

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
    if([[json objectForKey:kMMAlbum] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *album = [json objectForKey:kMMAlbum];
        albumContent.coverArtURL = [album objectForKey:kMMAlbumCoverArt];
        albumContent.title = [[album objectForKey:kMMAlbumTitle] stringByReplacingOccurrencesOfString:@"feat. " withString:@""];
    }
    
    albumContent.artist = [json objectForKey:kMMAlbumArtist];
    albumContent.major = [json objectForKey:kMMAlbumMajor];
    albumContent.minor = [json objectForKey:kMMAlbumMinor];
    albumContent.track = [json objectForKey:kMMAlbumTrack];
    albumContent.uuid = [json objectForKey:kMMAlbumUUID];
    albumContent.coverArtImage = [[UIImageView alloc] init];
    
    return albumContent;
    
}

@end
