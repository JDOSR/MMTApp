//
//  ViewController.m
//  MMTApp
//
//  Created by jasonowens on 2/27/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMTViewController.h"
#import "MMTNetworkManager.h"
#import "MMTLocationManager.h"
#import "MMAlbum.h"
#import "MMDevice.h"
#import "DetailView.h"
#import "PlaylistTableViewController.h"

static NSString * const cellIdentifier = @"MMTViewControllerIdentifier";
static NSString * const kLocationText = @"Thank you for visiting our 233 W Jackson Blvd location. Would you like to view the current playlist?";
static NSString * const kCLProximityAlertTitle = @"Beacon Found!";
static NSString * const kCLProximityAlertMsg = @"New Region ID (%@*) with minor %@";

@interface MMTViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView   *indicatorView;
@property (nonatomic, strong) UIView                    *animatedView;

@end

@implementation MMTViewController

#pragma - mark - Registering Observers

- (void)registerViewControllerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:kDataTaskCompletionNotificationDidFinishLoading
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(launchTableViewWithResults:)
                                                 name:kVCLaunchDisplayForLocatedBeacon
                                               object:nil];
}

- (void)unregisterViewControllerNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {
    [self unregisterViewControllerNotifications];
    [[MMTLocationManager sharedInstance] stopRangingForBeacons];
    [_indicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [MMTLocationManager sharedInstance].viewController = self;
    _alertController = nil;
    
    [self registerViewControllerNotifications];
    [MMTLocationManager sharedInstance];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[MMTLocationManager sharedInstance] startRangingForBeacons];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[MMTLocationManager sharedInstance] stopRangingForBeacons];
}

#pragma mark - Helper Methods

- (void)addIndicatorInView:(CGRect)frame {
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect indicatorFrame = CGRectMake(CGRectGetWidth(frame)/2,
                                       CGRectGetHeight(frame)/2,
                                       15.0,
                                       15.0);
    
    [_indicatorView setFrame:indicatorFrame];
    [self.view addSubview:_indicatorView];
    
    [_indicatorView setHidesWhenStopped:YES];
    [_indicatorView startAnimating];
    
}

- (void)addSlideView:(CGRect)frame {
    CGFloat posY = CGRectGetHeight(frame);
    CGRect uiViewFrame = CGRectMake(0.0, posY, CGRectGetWidth(frame), posY * 0.5);
    _animatedView = [[UIView alloc] initWithFrame:uiViewFrame];
    _animatedView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_animatedView];
    
}

- (void)reloadView {
    [_indicatorView stopAnimating];
//    self.results = [[MMTNetworkManager sharedInstance].results copy];

}

- (IBAction)launchTableViewWithResults:(id)sender {
    [[MMTNetworkManager sharedInstance] buildURLRequests];
    _alertController = [UIAlertController alertControllerWithTitle:@"Welcome to McDonalds!"
                                                           message:kLocationText
                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel Action")
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       _alertController = nil;
                                                   }];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:NSLocalizedString(@"View Playlist", @"View Playlist")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [self launchPlaylist];
                                               }];
    [_alertController addAction:yes];
    [_alertController addAction:cancel];
    
    [self presentViewController:_alertController animated:YES completion:^ {
    }];
}

- (void)launchPlaylist {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlaylistTableViewController *playlistTableViewController = (PlaylistTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PlaylistViewController"];
//    PlaylistTableViewController *playlistTableViewController = [[PlaylistTableViewController alloc] init];
    MMPlaylist *playlist = (MMPlaylist *)[[MMTNetworkManager sharedInstance] result];
    playlistTableViewController.results = [playlist.songs copy];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:playlistTableViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)launchActionSheetWithBeacon:(NSNotification *)notification {
    if([[notification object] isKindOfClass:[CLBeacon class]]) {
        CLBeacon *beacon = (CLBeacon *)[notification object];
        NSString *uuid_prefix = [[[beacon.proximityUUID UUIDString] componentsSeparatedByString:@"-"] firstObject];
        _alertController = [UIAlertController alertControllerWithTitle:kCLProximityAlertTitle
                                                               message:[NSString stringWithFormat:kCLProximityAlertMsg, uuid_prefix, [beacon minor]]
                                                        preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel Action")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           _alertController = nil;
                                                       }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Action")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       _alertController = nil;
                                                   }];
        [_alertController addAction:cancel];
        [_alertController addAction:ok];
        
        [self presentViewController:_alertController animated:YES completion:nil];
    }
    
}

@end
