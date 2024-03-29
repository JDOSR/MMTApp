//
//  MMTViewController.h
//  MMTApp
//
//  Created by jasonowens on 2/27/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface MMTViewController : UIViewController

@property (nonatomic, strong) NSDictionary  *devices;
@property (nonatomic, strong) NSArray       *results;
@property (nonatomic, strong) IBOutlet UIButton *launchAlbumMenu;
@property (nonatomic, strong) NSArray               *proximityArray;
@property (nonatomic, strong) UIAlertController         *alertController;
@property (weak, nonatomic) IBOutlet UIButton *activateBtn;

- (IBAction)launchTableViewWithResults:(id)sender;
- (void)launchActionSheetWithBeacon:(CLBeacon *)beacon;


@end

