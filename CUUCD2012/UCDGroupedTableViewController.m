//
//  UCDGroupedTableViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDGroupedTableViewController.h"
#import "UCDRightDetailGroupedTableViewCell.h"
#import "UCDButtonGroupedTableViewCell.h"
#import "UCDStyleManager.h"

@implementation UCDGroupedTableViewController

#pragma mark - UIViewController

- (void)loadView
{
    [[UCDStyleManager sharedManager] styleNavigationController:self.navigationController];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UCDViewBackground"]];
    self.tableView.backgroundView = backgroundView;
    [self.tableView registerClass:UCDRightDetailGroupedTableViewCell.class forCellReuseIdentifier:UCDRightDetailReuseIdentifier];
    [self.tableView registerClass:UCDButtonGroupedTableViewCell.class forCellReuseIdentifier:UCDButtonReuseIdentifier];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect headerLabelRect = [tableView rectForHeaderInSection:section];
    headerLabelRect.origin = CGPointMake(0.0, 0.0);
    headerLabelRect = CGRectInset(headerLabelRect, 16.0, 0.0);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerLabelRect];
    headerLabel.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    headerLabel.font = [UIFont fontWithName:@"Gotham HTF" size:17.0];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:headerLabel];
    return headerView;
}

@end
