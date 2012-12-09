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
#import "UCDStyleManager.h"

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

@interface UCDSettingsViewController ()

@property (nonatomic, strong) id managedObjectContextUpdateObserver;

@end

@implementation UCDSettingsViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.managedObjectContextUpdateObserver];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UCDNavigationTitleView alloc] initWithTitle:@"Ping" subtitle:@"Settings"];
    
    self.user = [[UCDAppDelegate sharedAppDelegate] currentUserInContext:self.managedObjectContext];
    
    self.managedObjectContextUpdateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext queue:NULL usingBlock:^(NSNotification *notification) {
        for (NSManagedObject *object in [notification.userInfo objectForKey:NSUpdatedObjectsKey]) {
            if (object == self.user) {
                [self.tableView reloadData];
            }
        }
    }];
    
    __weak typeof(self) blockSelf = self;
    SSPullToRefreshView *refreshView = [[UCDStyleManager sharedManager] pullToRefreshViewWithScrollView:self.tableView];
    A2DynamicDelegate *refreshViewDelegate = [refreshView dynamicDelegateForProtocol:@protocol(SSPullToRefreshViewDelegate)];
    [refreshViewDelegate implementMethod:@selector(pullToRefreshViewDidStartLoading:) withBlock:^(SSPullToRefreshView *view){
        [refreshView startLoading];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"SELF == %@", self.user];
        [blockSelf.managedObjectContext performBlockAndWait:^{
            [blockSelf.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        }];
        [refreshView finishLoading];
    }];
    refreshView.delegate = (id<SSPullToRefreshViewDelegate>)refreshViewDelegate;
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
                    cell.detailTextLabel.text = self.user.collectionIntervalDescription;
                    break;
                }
                case UCDSettingsTableViewSectionPingRowRadius: {
                    cell.textLabel.text = @"Ping Radius";
                    cell.detailTextLabel.text = self.user.accuracyRadiusDescription;
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
                    cell.detailTextLabel.text = self.user.occupation;
                    break;
                }
                case UCDSettingsTableViewSectionAboutRowGender: {
                    cell.textLabel.text = @"Gender";
                    cell.detailTextLabel.text = self.user.gender;
                    break;
                }
                case UCDSettingsTableViewSectionAboutRowBirthday: {
                    cell.textLabel.text = @"Birthday";
                    cell.detailTextLabel.text = self.user.birthdayDescription;
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
