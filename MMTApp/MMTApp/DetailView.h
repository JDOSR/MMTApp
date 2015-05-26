//
//  DetailView.h
//  MMTApp
//
//  Created by Jason Owens on 5/24/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *displayTableView;
@property (retain, nonatomic) UIImageView *imageView;
@property (nonatomic, retain) NSArray *results;

@end

