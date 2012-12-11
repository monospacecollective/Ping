//
//  UCDMasterViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDMasterViewController.h"
#import "UCDAppDelegate.h"
#import "UCDStyleManager.h"
#import "UCDMasterTableView.h"
#import "UCDMasterTableViewHeader.h"

#import "UCDPlacesViewController.h"
#import "UCDMapViewController.h"
#import "UCDPingsViewController.h"
#import "UCDSettingsViewController.h"

typedef NS_ENUM(NSUInteger, UCDMasterViewControllerTableViewSectionType) {
    UCDMasterViewControllerTableViewSectionTypePing,
    UCDMasterViewControllerTableViewSectionTypeSettings,
    UCDMasterViewControllerTableViewSectionTypeCount,
};

@interface UCDMasterViewController ()

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary *paneViewControllerIcons;
@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@end

@implementation UCDMasterViewController

#pragma mark - UIViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.paneViewControllerType = NSUIntegerMax;
        self.paneViewControllerTitles = @{
            @(UCDPaneViewControllerTypePlaces) : @"Nearby Places",
            @(UCDPaneViewControllerTypeMap) : @"Map",
            @(UCDPaneViewControllerTypePings) : @"My Pings",
            @(UCDPaneViewControllerTypeSettings) : @"Settings",
        };
        self.paneViewControllerIcons = @{
            @(UCDPaneViewControllerTypePlaces) : @"\U0001F4CD",
            @(UCDPaneViewControllerTypeMap) : @"\U0000E673",
            @(UCDPaneViewControllerTypePings) : @"\U000025CE",
            @(UCDPaneViewControllerTypeSettings) : @"\U00002699",
        };
        self.paneViewControllerClasses = @{
            @(UCDPaneViewControllerTypePlaces) : UCDPlacesViewController.class,
            @(UCDPaneViewControllerTypeMap) : UCDMapViewController.class,
            @(UCDPaneViewControllerTypePings) : UCDPingsViewController.class,
            @(UCDPaneViewControllerTypeSettings) : UCDSettingsViewController.class,
        };
        self.tableViewSectionBreaks = @[
            @(UCDPaneViewControllerTypeSettings),
            @(UCDPaneViewControllerTypeCount)
        ];
    }
    return self;
}

- (void)loadView
{
    self.tableView = [[UCDMasterTableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollsToTop = NO;
    [self.tableView registerClass:UCDMasterTableViewCell.class forCellReuseIdentifier:UCDMasterCellReuseIdentifier];
}

#pragma mark - UCDMasterViewController

- (UCDPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    UCDPaneViewControllerType paneViewControllerType;
    if (indexPath.section == 0) {
        paneViewControllerType = indexPath.row;
    } else {
        paneViewControllerType = [self.tableViewSectionBreaks[indexPath.section - 1] integerValue] + indexPath.row;
    }
    NSAssert(paneViewControllerType < UCDPaneViewControllerTypeCount, @"Invalid Index Path");
    return paneViewControllerType;
}

- (void)transitionToViewController:(UCDPaneViewControllerType)paneViewControllerType
{
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.navigationPaneViewController setPaneState:MSNavigationPaneStateClosed animated:YES];
        return;
    }
    
    BOOL animateTransition = self.navigationPaneViewController.paneViewController != nil;
    
    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    NSParameterAssert([paneViewControllerClass isSubclassOfClass:UIViewController.class]);
    UIViewController *paneViewController = (UIViewController *)[[paneViewControllerClass alloc] init];
    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    __weak typeof(self) blockSelf = self;
    paneViewController.navigationItem.leftBarButtonItem = [[UCDStyleManager sharedManager] barButtonItemWithImage:[UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"] action:^{
        [blockSelf.navigationPaneViewController setPaneState:MSNavigationPaneStateOpen animated:YES];
    }];
    
    if ([paneViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
        [paneViewController performSelector:@selector(setManagedObjectContext:) withObject:[[UCDAppDelegate sharedAppDelegate] managedObjectContext]];
    }
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    
    [self.navigationPaneViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return UCDMasterViewControllerTableViewSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.tableViewSectionBreaks[section] integerValue];
    } else {
        return ([self.tableViewSectionBreaks[section] integerValue] - [self.tableViewSectionBreaks[(section - 1)] integerValue]);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case UCDMasterViewControllerTableViewSectionTypePing:
            return @"Ping";
        case UCDMasterViewControllerTableViewSectionTypeSettings:
            return @"Configuration";
        default:
            return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (headerTitle == nil) {
        return nil;
    }
    UCDMasterTableViewHeader *headerView = [[UCDMasterTableViewHeader alloc] initWithFrame:CGRectZero];
    headerView.title.text = [headerTitle uppercaseString];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCDMasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UCDMasterCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.paneViewControllerTitles[@([self paneViewControllerTypeForIndexPath:indexPath])];
    cell.iconLabel.text = self.paneViewControllerIcons[@([self paneViewControllerTypeForIndexPath:indexPath])];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self transitionToViewController:[self paneViewControllerTypeForIndexPath:indexPath]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
