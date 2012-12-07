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
#import "UCDGroupedTableViewCell.h"
#import "UCDUser.h"

typedef NS_ENUM(NSUInteger, UCDSettingsTableViewSection) {
    UCDSettingsTableViewSectionInterval,
    UCDSettingsTableViewSectionRadius,
    UCDSettingsTableViewSectionAbout,
    UCDSettingsTableViewSectionSignOut,
    UCDSettingsTableViewSectionCount,
};

NSString * const UCDSettingsCellIdentifier = @"SettingsCell";

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
    [self.tableView registerClass:UCDGroupedTableViewCell.class forCellReuseIdentifier:UCDSettingsCellIdentifier];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UCDSettingsCellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case UCDSettingsTableViewSectionInterval: {
            cell.textLabel.text = @"Ping Interval";
            cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] collectionIntervalDescription];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case UCDSettingsTableViewSectionRadius: {
            cell.textLabel.text = @"Ping Radius";
            cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] accuracyRadiusDescription];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case UCDSettingsTableViewSectionAbout:
            cell.textLabel.text = @"About Me";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case UCDSettingsTableViewSectionSignOut:
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"Sign Out";
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case UCDSettingsTableViewSectionSignOut:
            [[UCDAppDelegate sharedAppDelegate] signOut];
            break;
    }
}

@end
