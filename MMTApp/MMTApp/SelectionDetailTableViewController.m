//
//  SelectionDetailTableViewController.m
//  MMTApp
//
//  Created by Jason Owens on 5/23/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "SelectionDetailTableViewController.h"
#import "MMAlbum.h"
#import "MMPlaylist.h"
#import "MMTNetworkManager.h"

static NSString * const kSingleRowContentIdentifier = @"kSingleRowContentIdentifier";

static NSString * const kHighestRatedTitle = @"Highest Rated Track";
static NSString * const kHighestRatedMsg = @"No need to worry, this track has been rated the most and will play following the track label 'Up Next'.  Thanks for participating, please enjoy your meal!";

@interface SelectionDetailTableViewController ()
@property (nonatomic, retain) MMAlbum *currentItem;
@property (nonatomic, retain) UIAlertController *alertController;
@end

@implementation SelectionDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _currentItem = (MMAlbum *)[self.results firstObject];
    self.cellView.backgroundColor = [UIColor lightGrayColor];

    self.coverView.image = _currentItem.coverArtImage.image;
    self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.textLabel.text = _currentItem.title;
    self.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", _currentItem.artist, _currentItem.album];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnToPlaylist)
                                                 name:kDataTaskCompletionNotificationDidFinishLoading
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)voteTrackUp:(id)sender {
    if(_currentItem.position > 3) {
        [[MMTNetworkManager sharedInstance] postDataWithParams:@{@"song_id": _currentItem.trackId}];
    } else {
        _alertController = [UIAlertController alertControllerWithTitle:@"Highest Rated Track"
                                                               message:kHighestRatedMsg
                                                        preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *thanks = [UIAlertAction actionWithTitle:NSLocalizedString(@"Thanks", @"OK Action")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       _alertController = nil;
                                                       [self returnToPlaylist];
                                                   }];
        [_alertController addAction:thanks];
        [self presentViewController:_alertController animated:YES completion:nil];
        
    }
}

- (void)returnToPlaylist {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
