//
//  MMAlbum.h
//  MMTApp
//
//  Created by jasonowens on 3/1/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *kMMAlbum;
extern NSString *kMMAlbumCoverArt;
extern NSString *kMMAlbumTitle;
extern NSString *kMMAlbumArtist;
extern NSString *kMMAlbumTrackID;

@interface MMAlbum : NSObject

@property (nonatomic, strong) NSString      *coverArtURL;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *album;
@property (nonatomic, strong) NSString      *artist;
@property (nonatomic, strong) NSString      *albumDescription;
@property (nonatomic, strong) NSString      *last_play_date;
@property (nonatomic, strong) NSNumber      *duration;
@property (nonatomic) NSInteger position;
@property (nonatomic, strong) NSNumber      *trackId;
@property (nonatomic, strong) UIImageView   *coverArtImage;


+(MMAlbum *)createAlbumFromDictionary:(NSDictionary *)json;

@end
