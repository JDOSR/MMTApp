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

static NSString * const kSingleRowContentIdentifier = @"kSingleRowContentIdentifier";

@interface SelectionDetailTableViewController ()
@property (nonatomic, retain) MMAlbum *currentItem;
@end

@implementation SelectionDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _currentItem = (MMAlbum *)[self.results firstObject];
    CGRect imageFrame = CGRectMake(0.0, 0.0, 320.0, 320.0);
    self.coverView = [[UIImageView alloc] initWithFrame:imageFrame];
    self.coverView.image = _currentItem.coverArtImage.image;
    [self.view addSubview:self.coverView];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSingleRowContentIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSingleRowContentIdentifier];
    }
    cell.textLabel.text = _currentItem.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", _currentItem.artist, _currentItem.album];

    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
