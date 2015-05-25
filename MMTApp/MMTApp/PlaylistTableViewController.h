//
//  PlaylistTableViewController.h
//  MMTApp
//
//  Created by Jason Owens on 5/23/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPlaylist.h"
#import "MMAlbum.h"

@interface PlaylistTableViewController : UITableViewController

@property (retain, nonatomic) IBOutlet UIView *currentView;
@property (nonatomic, retain) NSArray *results;
@end
