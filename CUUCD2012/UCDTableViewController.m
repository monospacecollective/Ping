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
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UCDViewBackground"]];
    self.tableView.backgroundView = backgroundView;
    self.tableView.separatorColor = [UIColor clearColor];
}

@end
