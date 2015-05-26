//
//  SelectionDetailTableViewController.h
//  MMTApp
//
//  Created by Jason Owens on 5/23/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionDetailTableViewController : UIViewController

@property (nonatomic, retain) NSArray *results;
@property (strong, nonatomic) IBOutlet UIImageView *coverView;
@property (strong, nonatomic) IBOutlet UIButton *voteBtn;
@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bgTexture;

- (IBAction)voteTrackUp:(id)sender;
@end
