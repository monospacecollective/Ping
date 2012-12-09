//
//  UCDPlacesViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlacesViewController.h"
#import "UCDPlace.h"
#import "UCDPlaceCell.h"
#import "UCDStyleManager.h"
#import "UCDNavigationTitleView.h"
#import "UCDTableView.h"
#import "UCDAppDelegate.h"

NSString * const UCDPlaceCellIdentifier = @"PlaceCell";

@interface UCDPlacesViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation UCDPlacesViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:UCDNotificationLocationManagerDidUpdate object:nil];
}

#pragma mark - UIViewController

- (void)loadView
{
    self.tableView = [[UCDTableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UCDNotificationLocationManagerDidUpdate object:nil];

    self.navigationItem.titleView = [[UCDNavigationTitleView alloc] initWithTitle:@"Ping" subtitle:@"Nearby Places"];
    [[UCDStyleManager sharedManager] styleToolbar:self.navigationController.toolbar];
    [[UCDStyleManager sharedManager] styleNavigationController:self.navigationController];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UCDViewBackground"]];
    self.tableView.separatorColor = [UIColor clearColor];
    
    __weak typeof(self) blockSelf = self;
    
    SSPullToRefreshView *refreshView = [[UCDStyleManager sharedManager] pullToRefreshViewWithScrollView:self.tableView];
    A2DynamicDelegate *refreshViewDelegate = [refreshView dynamicDelegateForProtocol:@protocol(SSPullToRefreshViewDelegate)];
    [refreshViewDelegate implementMethod:@selector(pullToRefreshViewDidStartLoading:) withBlock:^(SSPullToRefreshView *view){
        [refreshView startLoading];
        [blockSelf.fetchedResultsController performSelectorOnMainThread:@selector(performFetch:) withObject:nil waitUntilDone:YES modes:@[NSRunLoopCommonModes]];
        [refreshView finishLoading];
    }];
    refreshView.delegate = (id<SSPullToRefreshViewDelegate>)refreshViewDelegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    [self.tableView registerClass:UCDPlaceCell.class forCellReuseIdentifier:UCDPlaceCellIdentifier];
    
    [self.fetchedResultsController performFetch:nil];
    
    //    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES comparator:^NSComparisonResult(CLLocation *location1, CLLocation *location2) {
    //        if (blockSelf.locationManager.location == nil) {
    //            return NSOrderedSame;
    //        }
    //        CLLocationDistance distance1 = [location1 distanceFromLocation:blockSelf.locationManager.location];
    //        CLLocationDistance distance2 = [location2 distanceFromLocation:blockSelf.locationManager.location];
    //        return [@(distance1) compare:@(distance2)];
    //    }]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UCDPlacesViewController

- (void)configureCell:(UCDPlaceCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCDPlace *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.detail;
    
    TTTLocationFormatter *locationFormatter = [[TTTLocationFormatter alloc] init];
    [locationFormatter setBearingStyle:TTTBearingAbbreviationWordStyle];
    [locationFormatter setUnitSystem:TTTImperialSystem];
    locationFormatter.numberFormatter.maximumSignificantDigits = 1;
    cell.distanceLabel.text = [locationFormatter stringFromDistanceFromLocation:[UCDAppDelegate sharedAppDelegate].locationManager.location toLocation:place.location];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UCDPlaceCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
