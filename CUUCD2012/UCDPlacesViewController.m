//
//  UCDPlacesViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlacesViewController.h"
#import "UCDPlaceCell.h"
#import "UCDStyleManager.h"
#import "UCDNavigationTitleView.h"
#import "UCDAppDelegate.h"
#import "UCDPlaceViewController.h"
#import "UCDPlace.h"

NSString * const UCDPlaceCellIdentifier = @"PlaceCell";

@interface UCDPlacesViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSNumber *maxPeopleHere;

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateMaxPeopleHere;

@end

@implementation UCDPlacesViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:UCDNotificationLocationManagerDidUpdate object:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.maxPeopleHere = @(MAXFLOAT);
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UCDNotificationLocationManagerDidUpdate object:nil];
    [self.tableView registerClass:UCDPlaceCell.class forCellReuseIdentifier:UCDPlaceCellIdentifier];
    
    self.navigationItem.titleView = [[UCDNavigationTitleView alloc] initWithTitle:@"Ping" subtitle:@"Nearby Places"];
    [[UCDStyleManager sharedManager] styleToolbar:self.navigationController.toolbar];
    
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
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"peopleHere" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    [self updateMaxPeopleHere];
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
    
    CGFloat fill = (place.peopleHere.floatValue / self.maxPeopleHere.floatValue);
    cell.popularityView.fill = fill;
    
    TTTLocationFormatter *locationFormatter = [[TTTLocationFormatter alloc] init];
    [locationFormatter setBearingStyle:TTTBearingAbbreviationWordStyle];
    [locationFormatter setUnitSystem:TTTImperialSystem];
    locationFormatter.numberFormatter.maximumSignificantDigits = 1;
    cell.distanceLabel.text = [locationFormatter stringFromDistanceFromLocation:[UCDAppDelegate sharedAppDelegate].locationManager.location toLocation:place.location];
}

- (void)updateMaxPeopleHere
{
    NSUInteger maxPeopleHere = 0;
    for (UCDPlace *place in self.fetchedResultsController.fetchedObjects) {
        NSUInteger peopleHere = [place.peopleHere integerValue];
        if (peopleHere > maxPeopleHere) {
            maxPeopleHere = peopleHere;
        }
    }
    if ([self.maxPeopleHere integerValue] != maxPeopleHere) {
        self.maxPeopleHere = @(maxPeopleHere);
        [self.tableView reloadData];
    }
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
    UCDPlaceViewController *placeViewController = [[UCDPlaceViewController alloc] initWithNibName:nil bundle:nil];
    placeViewController.place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    __weak typeof(self) blockSelf = self;
    placeViewController.navigationItem.leftBarButtonItem = [[UCDStyleManager sharedManager] backBarButtonItemWithTitle:@"Back" action:^{
        [blockSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:placeViewController animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self updateMaxPeopleHere];
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
