//
//  UCDSettingsViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDSettingsViewController.h"
#import "UCDAppDelegate.h"
#import "UCDStyleManager.h"
#import "UCDNavigationTitleView.h"
#import "UCDUser.h"
#import "UCDRightDetailGroupedTableViewCell.h"
#import "UCDButtonGroupedTableViewCell.h"

typedef NS_ENUM(NSUInteger, UCDSettingsTableViewSection) {
    UCDSettingsTableViewSectionInterval,
    UCDSettingsTableViewSectionRadius,
    UCDSettingsTableViewSectionAbout,
    UCDSettingsTableViewSectionSignOut,
    UCDSettingsTableViewSectionCount,
};

typedef NS_ENUM(NSUInteger, UCDSettingsTableViewSectionAboutRow) {
    UCDSettingsTableViewSectionAboutRowOccupation,
    UCDSettingsTableViewSectionAboutRowBirthday,
    UCDSettingsTableViewSectionAboutRowGender,
    UCDSettingsTableViewSectionAboutRowCount,
};

@interface UCDSettingsViewController ()

@end

@implementation UCDSettingsViewController

- (void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UCDNavigationTitleView alloc] initWithTitle:@"Ping" subtitle:@"Settings"];
    [[UCDStyleManager sharedManager] styleNavigationController:self.navigationController];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UCDViewBackground"]];
    self.tableView.backgroundView = backgroundView;
    [self.tableView registerClass:UCDRightDetailGroupedTableViewCell.class forCellReuseIdentifier:UCDRightDetailReuseIdentifier];
    [self.tableView registerClass:UCDButtonGroupedTableViewCell.class forCellReuseIdentifier:UCDButtonReuseIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return UCDSettingsTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case UCDSettingsTableViewSectionAbout:
            return UCDSettingsTableViewSectionAboutRowCount;
        default:
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case UCDSettingsTableViewSectionAbout:
            return @"About Me";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case UCDSettingsTableViewSectionInterval: {
            cell = [tableView dequeueReusableCellWithIdentifier:UCDRightDetailReuseIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"Ping Interval";
            cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] collectionIntervalDescription];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case UCDSettingsTableViewSectionRadius: {
            cell = [tableView dequeueReusableCellWithIdentifier:UCDRightDetailReuseIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"Ping Radius";
            cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] accuracyRadiusDescription];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case UCDSettingsTableViewSectionAbout: {
            cell = [tableView dequeueReusableCellWithIdentifier:UCDRightDetailReuseIdentifier forIndexPath:indexPath];
            switch (indexPath.row) {
                case UCDSettingsTableViewSectionAboutRowOccupation: {
                    cell.textLabel.text = @"Occupation";
                    cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] occupation];
                    break;
                }
                case UCDSettingsTableViewSectionAboutRowGender: {
                    cell.textLabel.text = @"Gender";
                    cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] gender];
                    break;
                }
                case UCDSettingsTableViewSectionAboutRowBirthday: {
                    cell.textLabel.text = @"Birthday";
                    cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] birthdayDescription];
                    break;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case UCDSettingsTableViewSectionSignOut: {
            cell = [tableView dequeueReusableCellWithIdentifier:UCDButtonReuseIdentifier forIndexPath:indexPath];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"Sign Out";
            break;
        }
    }
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case UCDSettingsTableViewSectionSignOut:
            [[UCDAppDelegate sharedAppDelegate] signOut];
            break;
    }
}

@end
