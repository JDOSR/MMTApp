//
//  PlaylistTableViewController.m
//  MMTApp
//
//  Created by Jason Owens on 5/23/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "PlaylistTableViewController.h"
#import "CustomSelectionTableViewCell.h"
#import "SelectionDetailTableViewController.h"
#import "DetailView.h"
#import "MMTNetworkManager.h"

static NSString * const kPushToVoteIdentifier = @"pushToVoteIdentifier";
static NSString * const kPlayListOptionsIdentifier = @"kPlayListOptionsIdentifier";

static NSString * const kDetailView = @"DetailViewForTableHeaderView";

@interface PlaylistTableViewController ()
@property (nonatomic, retain) MMAlbum *selectedAlbum;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) BOOL animateRows;
@end

@implementation PlaylistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    _animateRows = NO;

    CGRect tableViewFrame = CGRectMake(0.0, 0.0, 320.0, 300.0);
    self.currentView = nil;
    self.currentView = [[DetailView alloc] initWithFrame:tableViewFrame];
    [self.tableView setTableHeaderView:self.currentView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(prepareForAnimationOfRows)
                                                 name:kDataTaskCompletionNotificationDidFinishLoading
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MMPlaylist *playlist = (MMPlaylist *)[[MMTNetworkManager sharedInstance] result];
    NSInteger startingRecordCrop = 3;
    NSInteger totalRecordsLeft = [playlist.songs count] - startingRecordCrop;
    [self.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        MMAlbum *al = (MMAlbum *)obj;
        NSLog(@"Album Name: %@ Album Position: %li", al.title, (unsigned long)al.position);
    }];
    self.results = [playlist.songs subarrayWithRange:NSMakeRange(startingRecordCrop, totalRecordsLeft)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(_animateRows) {
        NSUInteger newIndex = [self.results indexOfObject:_selectedAlbum];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newIndex inSection:0];
        if([_selectedIndexPath compare:newIndexPath] != NSOrderedSame) {
            [self.tableView moveRowAtIndexPath:_selectedIndexPath toIndexPath:newIndexPath];
            _animateRows = NO;
            [self.tableView reloadData];
        }
    } else {
        [self.tableView deselectRowAtIndexPath:_selectedIndexPath animated:YES];
    }
}

- (void)prepareForAnimationOfRows {
    _animateRows = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return [self.results count];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlayListOptionsIdentifier];
    if(!cell) {
        cell = [[CustomSelectionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kPlayListOptionsIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CustomSelectionTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    MMAlbum *al = (MMAlbum *)[self.results objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.textLabel.text = al.title;
    UIFontDescriptor *descriptor = [cell.detailTextLabel.font.fontDescriptor
                                fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    cell.detailTextLabel.font = [UIFont fontWithDescriptor:descriptor size:16.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", al.artist, al.album];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedAlbum = (MMAlbum *)[self.results objectAtIndex:[indexPath row]];
    _selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:kPushToVoteIdentifier sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kPushToVoteIdentifier]) {
        SelectionDetailTableViewController *selectedViewController = (SelectionDetailTableViewController *)[segue destinationViewController];
        selectedViewController.results = @[_selectedAlbum];
    }
}

@end
