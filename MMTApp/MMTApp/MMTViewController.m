//
//  ViewController.m
//  MMTApp
//
//  Created by jasonowens on 2/27/15.
//  Copyright (c) 2015 Jason Owens. All rights reserved.
//

#import "MMTViewController.h"
#import "MMTNetworkManager.h"
#import "MMTLocationManager.h"
#import "MMAlbum.h"

static NSString * const cellIdentifier = @"MMTViewControllerIdentifier";
static NSString * const kCLProximityAlertTitle = @"Beacon Found!";
static NSString * const kCLProximityAlertMsg = @"You are in proximity of beacon with minor %li";

@interface MMTViewController ()

@property (nonatomic, strong) UIActivityIndicatorView   *indicatorView;
@property (nonatomic, strong) UIAlertController         *alertController;
@property (nonatomic, strong) UIView                    *animatedView;

@end

@implementation MMTViewController


- (void)dealloc {
    [self unregisterViewControllerNotifications];
    [[MMTLocationManager sharedInstance] stopRanging];
    [_indicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    CGFloat posY = CGRectGetHeight(screen);
    CGRect uiViewFrame = CGRectMake(0.0, posY, CGRectGetWidth(screen), posY * 0.5);
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect indicatorFrame = CGRectMake(CGRectGetWidth(screen)/2,
                                       CGRectGetHeight(screen)/2,
                                       15.0,
                                       15.0);
    
    [_indicatorView setFrame:indicatorFrame];
    [self.view addSubview:_indicatorView];
    
    [_indicatorView setHidesWhenStopped:YES];
    [_indicatorView startAnimating];

    _animatedView = [[UIView alloc] initWithFrame:uiViewFrame];
    _animatedView.backgroundColor = [UIColor blackColor];
    
    
    CGRect tableViewFrame = CGRectMake(0.0, 20.0, CGRectGetWidth(screen), CGRectGetHeight(uiViewFrame));
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_animatedView addSubview:self.tableView];

    UIButton *closeButton = [self getCloseButton];
    [_animatedView addSubview:closeButton];
    [self.view addSubview:_animatedView];

    [MMTLocationManager sharedInstance].viewController = self;
    _alertController = nil;
    [self registerViewControllerNotifications];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)reloadView {
    [_indicatorView stopAnimating];
    self.results = [[MMTNetworkManager sharedInstance].results copy];
    self.devices = [[MMTLocationManager sharedInstance].beacons copy];
    [self.tableView reloadData];

}

- (UIButton *)getCloseButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 2.0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 20.0)];
    [button setTitleColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor colorWithRed:(0/255.0) green:(118/255.0) blue:(182/255.0) alpha:1.0]];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [button addTarget:self action:@selector(closeTableView) forControlEvents:UIControlEventAllTouchEvents];
    
    return button;
    
}

- (IBAction)launchTableViewWithResults:(id)sender {
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect frame = _animatedView.frame;
                         frame.origin.y = CGRectGetMinY(frame) * 0.5;
                         _animatedView.frame = frame;
                     }
                     completion:nil];
}

- (void)closeTableView {
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect frame = _animatedView.frame;
                         frame.origin.y = CGRectGetMaxY(frame);
                         _animatedView.frame = frame;
                     }
                     completion:nil];
}

- (void)launchActionSheetWithBeacon:(CLBeacon *)beacon {
    _alertController = [UIAlertController alertControllerWithTitle:kCLProximityAlertTitle
                                                           message:[NSString stringWithFormat:kCLProximityAlertMsg, (long)beacon.minor]
                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel Action")
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {}];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Action")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {}];
    [_alertController addAction:cancel];
    [_alertController addAction:ok];
    
    [self presentViewController:_alertController animated:YES completion:nil];
    
}

#pragma - mark - Registering Observers

- (void)registerViewControllerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:kDataTaskCompletionNotificationDidFinishLoading
                                               object:nil];
}

- (void)unregisterViewControllerNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - View Controller Delegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path {
    MMAlbum *album = [self.results objectAtIndex:path.row];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (Minor: %li)", album.title, (long)album.minor];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", album.artist, album.track];
    
    cell.imageView.image = album.coverArtImage.image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
