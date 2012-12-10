//
//  UCDMapViewController.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/10/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDMapViewController.h"
#import "UCDNavigationTitleView.h"
#import "UCDStyleManager.h"
#import "UCDPlace.h"
#import "UCDAppDelegate.h"

NSString * const UCDMapViewControllerPlaceAnnotationReuseIdentifier = @"MapViewControllerPlaceAnnotationReuseIdentifier";
CGFloat const UCDMapViewControllerZoomRegion = 5000.0;

@interface UCDMapViewController () <MKMapViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)zoomToUserAnimated:(BOOL)animated;

@end

@implementation UCDMapViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UCDNavigationTitleView alloc] initWithTitle:@"Ping" subtitle:@"Map"];
    [[UCDStyleManager sharedManager] styleNavigationController:self.navigationController];
    
    __weak typeof(self) blockSelf = self;
    self.navigationItem.rightBarButtonItem = [[UCDStyleManager sharedManager] barButtonItemWithSymbolSetTitle:@"\U0000E670" action:^{
        [blockSelf zoomToUserAnimated:YES];
    }];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    [self zoomToUserAnimated:NO];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UCDMapViewController

- (void)zoomToUserAnimated:(BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[UCDAppDelegate sharedAppDelegate] locationManager] location].coordinate, UCDMapViewControllerZoomRegion, UCDMapViewControllerZoomRegion);
    [self.mapView setRegion:region animated:animated];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.mapView removeAnnotations:self.fetchedResultsController.fetchedObjects];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.mapView addAnnotations:self.fetchedResultsController.fetchedObjects];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:UCDPlace.class]) {
        MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:UCDMapViewControllerPlaceAnnotationReuseIdentifier];
        if (pinAnnotation == nil) {
            pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:UCDMapViewControllerPlaceAnnotationReuseIdentifier];
            pinAnnotation.animatesDrop = YES;
        } else {
            pinAnnotation.annotation = annotation;
        }
        return pinAnnotation;
    } else {
        return nil;
    }
}

@end
