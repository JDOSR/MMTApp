//
//  MMTNetworkManager.m
//  MMTApp
//
//  Created by jasonowens on 3/1/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMTNetworkManager.h"
#import "MMDevice.h"
#import "MMAlbum.h"

@interface MMTNetworkManager()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation MMTNetworkManager


+ (MMTNetworkManager *)sharedInstance {
    static MMTNetworkManager *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return(instance);
}

- (id)init {
    self = [super init];
    if(self) {
        _session = [NSURLSession sharedSession];
    }
    return self;
}


- (void)buildURLRequests {
    self.result = nil;
    [self getDataFromURL:kMMDataPlaylistURL];
}

- (void)getDataFromURL:(NSString *)url {
    [[_session dataTaskWithURL:[NSURL URLWithString:url]
             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if(response && !error) {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        [self loadData:json];
                    }
    }] resume];
}

- (BOOL)postDataWithParams:(NSDictionary *)params{
    NSError *error;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kMMPOSTUrl]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *mmData = [NSJSONSerialization dataWithJSONObject:params
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
    [request setHTTPBody:mmData];
    
    [[_session dataTaskWithRequest:request
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     if(response && !error) {
                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             [self loadData:json];
                             NSDictionary *success = @{@"success": @"YES"};
                             [[NSNotificationCenter defaultCenter] postNotificationName:kDataTaskCompletionNotificationDidFinishLoading
                                                                                 object:success];
                         });
                     }
                 }] resume];
    return NO;
}


- (void)downloadImageForAlbum:(MMAlbum *)album {
    [[_session downloadTaskWithURL:[NSURL URLWithString:album.coverArtURL]
                 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                     if(response && !error) {
                         UIImage *coverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                         if(coverImage) {
                             [album.coverArtImage setImage:coverImage];
                         }
                     }
                 }] resume];
}

- (void)loadData:(NSDictionary *)json {
    MMPlaylist *playlist = [[MMPlaylist alloc] init];
    playlist.playlistID = [json objectForKey:kMMID];
    playlist.playlistName = [json objectForKey:kMMPlaylistName];
    playlist.time = [json objectForKey:kMMPlaylistTS];
    
    if([[json objectForKey:kMMPlaylistSongs] isKindOfClass:[NSArray class]]) {
        NSArray *songs = [json objectForKey:kMMPlaylistSongs];
        [songs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MMAlbum *newAlbum = [MMAlbum createAlbumFromDictionary:(NSDictionary *)obj];
            [playlist.songs addObject:newAlbum];
            [self downloadImageForAlbum:newAlbum];
        }];
    }
    self.result = playlist;
}

@end
