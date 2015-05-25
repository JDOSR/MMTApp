//
//  DetailView.m
//  MMTApp
//
//  Created by Jason Owens on 5/24/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "DetailView.h"
#import "MMTNetworkManager.h"
#import "MMPlaylist.h"
#import "MMAlbum.h"


static NSString * const cellIdentifier = @"DisplayTableViewIdentifier";
static NSString *const kVendorTextString = @"Influence the playlist by selecting a track below:";
static NSString *const kVendorSuccessString = @"Yes! Your selection has been updated! We hope you'll love it!";

@interface DetailView ()

@end

@implementation DetailView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        CGFloat heightForCustomDisplayTable = 140.0f;
        CGRect tableFrame = CGRectMake(2.0, 2.0, 316.0, heightForCustomDisplayTable);
        CGRect labelViewFrame = CGRectMake(8.0, 50.0f+CGRectGetHeight(tableFrame), CGRectGetWidth(tableFrame)-10.0f, 80.0f);
        CGRect textFieldFrame = CGRectMake(35.0, 4.0, 250.0, heightForCustomDisplayTable/2);

        self.displayTableView = [[UITableView alloc] initWithFrame:tableFrame
                                                             style:UITableViewStylePlain];
        self.displayTableView.delegate = self;
        self.displayTableView.dataSource = self;
        
        self.displayTableView.rowHeight = heightForCustomDisplayTable/2;
        MMPlaylist *playlist = (MMPlaylist *)[[MMTNetworkManager sharedInstance] result];
        self.results = [playlist.songs subarrayWithRange:NSMakeRange(0, 2)];
        [self addSubview:self.displayTableView];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:textFieldFrame];
        textView.text = [NSString stringWithFormat:kVendorTextString];
        textView.font = [UIFont boldSystemFontOfSize:20.0f];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.textColor = [UIColor blackColor];
        
        UIView *labelView = [[UIView alloc] initWithFrame:labelViewFrame];
        labelView.backgroundColor = [UIColor whiteColor];

        [labelView addSubview:textView];
        [self addSubview:labelView];
        
//    if([self.results count] > 1) {
//        [self.results sortedArrayUsingComparator:^NSComparisonResult(MMAlbum* obj1, MMAlbum* obj2) {
//            if(obj1.position > obj2.position) {
//                return NSOrderedDescending;
//            }
//            return NSOrderedSame;
//        }];
//    }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    MMAlbum *al = (MMAlbum *)[self.results objectAtIndex:[indexPath row]];
    cell.textLabel.text = al.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", al.artist, al.album];
    cell.imageView.image = al.coverArtImage.image;
}
@end
