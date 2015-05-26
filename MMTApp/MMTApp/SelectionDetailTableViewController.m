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

@interface SelectionDetailTableViewController ()
@property (nonatomic, retain) MMAlbum *currentItem;
@end

@implementation SelectionDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _currentItem = (MMAlbum *)[self.results firstObject];
    self.cellView.backgroundColor = [UIColor lightGrayColor];
//    self.bgTexture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TexturedBackgroundColor"]];

    self.coverView.image = _currentItem.coverArtImage.image;
    self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.textLabel.text = _currentItem.title;
    self.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", _currentItem.artist, _currentItem.album];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnToPlaylist)
                                                 name:kDataTaskCompletionNotificationDidFinishLoading
                                               object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)voteTrackUp:(id)sender {
    [[MMTNetworkManager sharedInstance] postDataWithParams:@{@"song_id": _currentItem.trackId}];
// Test Code
//    NSDictionary *success = @{@"success" : @"YES"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:kDataTaskCompletionNotificationDidFinishLoading
//                                                        object:success];

}

- (void)returnToPlaylist {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
