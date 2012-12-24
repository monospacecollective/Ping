//
//  UCDTableViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDTableViewController.h"
#import "UCDTableView.h"
#import "UCDStyleManager.h"

@implementation UCDTableViewController

- (void)loadView
{
    self.tableView = [[UCDTableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UCDStyleManager sharedManager] styleNavigationController:self.navigationController];
    
    self.tableView.backgroundColor = [[UCDStyleManager sharedManager] viewBackgroundColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor clearColor];
}

@end
