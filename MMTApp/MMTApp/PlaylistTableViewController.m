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
@end

@implementation PlaylistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    CGRect tableViewFrame = CGRectMake(0.0, 0.0, 320.0, 300.0);

    self.currentView = [[DetailView alloc] initWithFrame:tableViewFrame];
    [self.tableView setTableHeaderView:self.currentView];
    MMPlaylist *playlist = (MMPlaylist *)[[MMTNetworkManager sharedInstance] result];
    
    NSInteger startingRecordCrop = 3;
    NSInteger totalRecordsLeft = [playlist.songs count] - startingRecordCrop;
    self.results = [playlist.songs subarrayWithRange:NSMakeRange(startingRecordCrop, totalRecordsLeft)];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    cell.textLabel.text = al.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", al.artist, al.album];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedAlbum = (MMAlbum *)[self.results objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:kPushToVoteIdentifier sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kPushToVoteIdentifier]) {
        SelectionDetailTableViewController *selectedViewController = (SelectionDetailTableViewController *)[segue destinationViewController];
        selectedViewController.results = @[_selectedAlbum];
    }
}

@end
