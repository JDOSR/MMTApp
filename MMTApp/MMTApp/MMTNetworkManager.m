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

static NSString * const kNMApiUrl = @"https://s3.amazonaws.com/ibeacon-mock/%@/%@/%@.json";

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
        self.results = [[NSMutableArray alloc] initWithCapacity:1];
        [self buildURLRequests];
    }
    return self;
}


- (void)buildURLRequests {
    [self.results removeAllObjects];
    [[MMDevice sharedInstance].supportedUUIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[NSDictionary class]]) {
            NSUUID *uuid = (NSUUID *)[(NSDictionary *)obj objectForKey:kUUIDKey];
            NSString *url = [NSString stringWithFormat:kNMApiUrl, [uuid UUIDString],
                             (NSString *)[(NSDictionary *)obj objectForKey:kUUIDMajorKey],
                             (NSString *)[(NSDictionary *)obj objectForKey:kUUIDMinorKey]];
            [self getDataFromURL:url];
        }
    }];
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

- (void)downloadImageForAlbum:(MMAlbum *)album {
    [[_session downloadTaskWithURL:[NSURL URLWithString:album.coverArtURL]
                 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                     if(response && !error) {
                        album.coverArtImage = [UIImage imageNamed:[location absoluteString]];
                        [self.results addObject:album];
                         [self updateViewController];
                     }
                 }] resume];
}

- (void)loadData:(NSDictionary *)json {
    MMAlbum *newAlbum = [MMAlbum createAlbumFromDictionary:json];
    [self downloadImageForAlbum:newAlbum];
}

- (void)updateViewController {
    if([self.results count] == [[MMDevice sharedInstance].supportedUUIDs count]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDataTaskCompletionNotificationDidFinishLoading object:nil];
    }
}

@end
