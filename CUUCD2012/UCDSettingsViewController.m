//
//  UCDSettingsViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDSettingsViewController.h"
#import "UCDAppDelegate.h"
#import "UCDNavigationTitleView.h"
#import "UCDUser.h"

typedef NS_ENUM(NSUInteger, UCDSettingsTableViewSection) {
    UCDSettingsTableViewSectionPing,
    UCDSettingsTableViewSectionAbout,
    UCDSettingsTableViewSectionSignOut,
    UCDSettingsTableViewSectionCount,
};

typedef NS_ENUM(NSUInteger, UCDSettingsTableViewSectionPingRow) {
    UCDSettingsTableViewSectionPingRowInterval,
    UCDSettingsTableViewSectionPingRowRadius,
    UCDSettingsTableViewSectionPingRowCount,
};

typedef NS_ENUM(NSUInteger, UCDSettingsTableViewSectionAboutRow) {
    UCDSettingsTableViewSectionAboutRowOccupation,
    UCDSettingsTableViewSectionAboutRowBirthday,
    UCDSettingsTableViewSectionAboutRowGender,
    UCDSettingsTableViewSectionAboutRowCount,
};

@implementation UCDSettingsViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UCDNavigationTitleView alloc] initWithTitle:@"Ping" subtitle:@"Settings"];
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
        case UCDSettingsTableViewSectionPing:
            return UCDSettingsTableViewSectionPingRowCount;
        case UCDSettingsTableViewSectionSignOut:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case UCDSettingsTableViewSectionPing: {
            cell = [tableView dequeueReusableCellWithIdentifier:UCDRightDetailReuseIdentifier forIndexPath:indexPath];
            switch (indexPath.row) {
                case UCDSettingsTableViewSectionPingRowInterval: {
                    cell.textLabel.text = @"Ping Interval";
                    cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] collectionIntervalDescription];
                    break;
                }
                case UCDSettingsTableViewSectionPingRowRadius: {
                    cell.textLabel.text = @"Ping Radius";
                    cell.detailTextLabel.text = [[UCDUser currentUserInContext:self.managedObjectContext] accuracyRadiusDescription];
                    break;
                }
            }
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
            cell.textLabel.text = @"Sign Out";
            break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case UCDSettingsTableViewSectionSignOut: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you want to sign out? You will lose all data associated with your account and will not be able to sign back in." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign Out", nil];
            A2DynamicDelegate *dynamicDelegate = alertView.dynamicDelegate;
            [dynamicDelegate implementMethod:@selector(alertView:didDismissWithButtonIndex:) withBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UCDAppDelegate sharedAppDelegate] signOut];
                }
            }];
            alertView.delegate = dynamicDelegate;
            [alertView show];
            break;
        }
    }
}

@end
