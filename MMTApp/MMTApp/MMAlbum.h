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
extern NSString *kMMAlbumMajor;
extern NSString *kMMAlbumMinor;
extern NSString *kMMAlbumTrack;
extern NSString *kMMAlbumUUID;

@interface MMAlbum : NSObject

@property (nonatomic, strong) NSString      *coverArtURL;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *artist;
@property (nonatomic, strong) NSNumber      *major;
@property (nonatomic, strong) NSNumber      *minor;
@property (nonatomic, strong) NSString      *track;
@property (nonatomic, strong) NSString      *uuid;
@property (nonatomic, strong) UIImageView   *coverArtImage;

+(MMAlbum *)createAlbumFromDictionary:(NSDictionary *)json;

@end
