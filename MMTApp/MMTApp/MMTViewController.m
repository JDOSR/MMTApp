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

static NSString * const cellIdentifier = @"MMTTableViewControllerIdentifier";

@interface MMTViewController () 

@property (nonatomic, retain) MMTNetworkManager *dataManager;
@property (nonatomic, retain) MMTLocationManager *locManager;

@end

@implementation MMTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _locManager = [MMTLocationManager sharedInstance];
    _dataManager = [MMTNetworkManager sharedInstance];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [_dataManager.results count];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
