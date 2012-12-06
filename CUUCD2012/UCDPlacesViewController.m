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

NSString * const UCDPlaceCellIdentifier = @"PlaceCell";

@interface UCDPlacesViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation UCDPlacesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Places";
    [[UCDStyleManager sharedManager] styleNavigationController:self.navigationController];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UCDViewBackground"]];
    self.tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    __weak typeof(self) blockSelf = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addEventHandler:^{
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
        [blockSelf.refreshControl endRefreshing];
    } forControlEvents:UIControlEventValueChanged];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = 1.0;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    A2DynamicDelegate *locationManagerDynamicDelegate = [self.locationManager dynamicDelegateForProtocol:@protocol(CLLocationManagerDelegate)];
    [locationManagerDynamicDelegate implementMethod:@selector(locationManager:didUpdateToLocation:fromLocation:) withBlock:^(CLLocationManager *locationManager, CLLocation *newLocation, CLLocation *oldLocation){
        [blockSelf.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
    }];
    self.locationManager.delegate = (id<CLLocationManagerDelegate>)locationManagerDynamicDelegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
//    A2DynamicDelegate *fetchedResultsControllerDynamicDelegate = [self.fetchedResultsController dynamicDelegateForProtocol:@protocol(NSFetchedResultsControllerDelegate)];
//    [fetchedResultsControllerDynamicDelegate implementMethod:@selector(controllerDidChangeContent:) withBlock:^(NSFetchedResultsController *fetchedResultsController){
//        [self.tableView reloadData];
//    }];
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

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCDPlace *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = place.name;
    
    TTTLocationFormatter *locationFormatter = [[TTTLocationFormatter alloc] init];
    [locationFormatter setBearingStyle:TTTBearingAbbreviationWordStyle];
    [locationFormatter setUnitSystem:TTTImperialSystem];
    locationFormatter.numberFormatter.maximumSignificantDigits = 1;
    cell.detailTextLabel.text = [locationFormatter stringFromDistanceFromLocation:self.locationManager.location toLocation:place.location];
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
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

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
