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
        CGRect tableFrame = CGRectMake(2.0, 2.0, 316.0, heightForCustomDisplayTable);
        CGRect labelViewFrame = CGRectMake(8.0, 50.0f+CGRectGetHeight(tableFrame), CGRectGetWidth(tableFrame)-10.0f, 70.0f);
        CGRect textFieldFrame = CGRectMake(25.0, 2.0, 250.0, heightForCustomDisplayTable/2);

        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:frame];
        backgroundImage.image = [UIImage imageNamed:@"bg-nobrand"];
        [self addSubview:backgroundImage];
        
        self.displayTableView = [[UITableView alloc] initWithFrame:tableFrame
                                                             style:UITableViewStylePlain];
        self.displayTableView.delegate = self;
        self.displayTableView.dataSource = self;
        
        self.displayTableView.rowHeight = heightForCustomDisplayTable/2;
        MMPlaylist *playlist = (MMPlaylist *)[[MMTNetworkManager sharedInstance] result];
        self.results = [playlist.songs subarrayWithRange:NSMakeRange(0, 2)];
        [self addSubview:self.displayTableView];
        
        self.textView = [[UITextView alloc] initWithFrame:textFieldFrame];
        self.textView.text = [NSString stringWithFormat:kVendorTextString];

        self.textView.font = [UIFont boldSystemFontOfSize:18.0f];
        self.textView.textAlignment = NSTextAlignmentCenter;
        self.textView.textColor = [UIColor blackColor];
        self.textView.backgroundColor = [UIColor clearColor];
        
        UIView *labelView = [[UIView alloc] initWithFrame:labelViewFrame];
        labelView.backgroundColor = [UIColor whiteColor];

        [labelView addSubview:self.textView];
        [self addSubview:labelView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLabel:)
                                                     name:kDataTaskCompletionNotificationDidFinishLoading
                                                   object:nil];
        
    }
    return self;
}

- (void)updateLabel:(NSNotification *)response {
    NSDictionary *state = response.object;
    if([state objectForKey:@"success"]) {
        self.textView.text = [NSString stringWithFormat:kVendorSuccessString];
    } else {
        self.textView.text = [NSString stringWithFormat:kVendorTextString];
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
    CGRect frame = CGRectMake(100.0, 0.0, 200.0, 20.0);
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
@end
