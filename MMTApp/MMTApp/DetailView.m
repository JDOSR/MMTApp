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
static NSString *const kVendorSuccessString = @"Yes! Your selection has been updated! Are you lovin' it?";

@interface DetailView ()
@property (nonatomic, assign) BOOL labelState;

@end

@implementation DetailView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        CGFloat heightForCustomDisplayTable = 140.0f;
        CGRect tableFrame = CGRectMake(0.0, 0.0, 320.0, heightForCustomDisplayTable + 1.0);
        CGRect textFieldFrame = CGRectMake(0.0, 50.0f+CGRectGetHeight(tableFrame), 320.0, 54.0);
        self.backgroundColor = [UIColor blackColor];
        
        self.displayTableView = [[UITableView alloc] initWithFrame:tableFrame
                                                             style:UITableViewStylePlain];
        self.displayTableView.delegate = self;
        self.displayTableView.dataSource = self;
        
        self.displayTableView.rowHeight = heightForCustomDisplayTable/2;
        MMPlaylist *playlist = (MMPlaylist *)[[MMTNetworkManager sharedInstance] result];
        self.results = [playlist.songs subarrayWithRange:NSMakeRange(0, 2)];
        [self addSubview:self.displayTableView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:textFieldFrame];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.image = [UIImage imageNamed:@"influence"];
        
        [self addSubview:self.imageView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLabel:)
                                                     name:kDataTaskCompletionNotificationDidFinishLoading
                                                   object:nil];
        
    }
    return self;
}

- (void)updateLabel:(NSNotification *)notification {
    NSDictionary *state = notification.object;
    if([state objectForKey:@"success"]) {
        self.imageView.image = [UIImage imageNamed:@"success"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"influence"];
    }
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
    CGRect frame = CGRectMake(100.0, 0.0, 200.0, 20.0);
    
    MMAlbum *al = (MMAlbum *)[self.results objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.textLabel.text = al.title;

    cell.imageView.image = [UIImage imageNamed:@"defaultThumbNail"];
    UIFontDescriptor *descriptor = [cell.detailTextLabel.font.fontDescriptor
                                    fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    cell.detailTextLabel.font = [UIFont fontWithDescriptor:descriptor size:12.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", al.artist, al.album];
    if(al.coverArtImage.image) {
        cell.imageView.image = al.coverArtImage.image;
    }
    switch ([indexPath row]) {
        case 0:{
            
            UILabel *statusPlayingLabel = [[UILabel alloc] initWithFrame:frame];
            statusPlayingLabel.font = [UIFont systemFontOfSize:12.0];
            statusPlayingLabel.text = @"Now Playing:";
            [cell.contentView addSubview:statusPlayingLabel];
            break;
        }
        case 1:{
            UILabel *statusNextLabel = [[UILabel alloc] initWithFrame:frame];
            statusNextLabel.font = [UIFont systemFontOfSize:12.0];
            statusNextLabel.text = @"Up Next:";
            [cell.contentView addSubview:statusNextLabel];
            
        }
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
