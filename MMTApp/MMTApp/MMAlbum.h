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

@property (nonatomic, strong) NSString *coverArtURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;
@property (nonatomic, strong) NSString *track;
@property (nonatomic, strong) NSString *uuid;

+(MMAlbum *)createAlbumFromDictionary:(NSDictionary *)json;

@end
