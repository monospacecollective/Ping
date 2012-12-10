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
#import "UCDPlaceAnnotation.h"
#import "UCDPlaceViewController.h"
#import "UCDPopularityView.h"

NSString * const UCDMapViewControllerPlaceAnnotationReuseIdentifier = @"MapViewControllerPlaceAnnotationReuseIdentifier";
CGFloat const UCDMapViewControllerZoomRegion = 1250.0;

@interface UCDMapViewController () <MKMapViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSNumber *maxPeopleHere;

- (void)zoomToUserAnimated:(BOOL)animated;
- (void)addPlaceAnnotations;
- (void)removePlaceAnnotations;
- (void)updateMaxPeopleHere;
- (UCDPlaceAnnotation *)annotationForPlace:(UCDPlace *)place;

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
    [self updateMaxPeopleHere];
    
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

- (void)addPlaceAnnotations
{
    NSMutableArray *placeAnnotations = [NSMutableArray array];
    for (UCDPlace *place in self.fetchedResultsController.fetchedObjects) {
        
        UCDPlaceAnnotation *placeAnnotation = [[UCDPlaceAnnotation alloc] initWithPlace:place];
        [placeAnnotations addObject:placeAnnotation];
    }
    [self.mapView addAnnotations:placeAnnotations];
}

- (void)removePlaceAnnotations
{
    for (id<MKAnnotation>annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:UCDPlaceAnnotation.class]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
}

- (UCDPlaceAnnotation *)annotationForPlace:(UCDPlace *)place
{
    for (id<MKAnnotation>annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:UCDPlaceAnnotation.class] && (((UCDPlaceAnnotation *)annotation).place == place)) {
            return (UCDPlaceAnnotation *)annotation;
        }
    }
    return nil;
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
        [self removePlaceAnnotations];
        [self addPlaceAnnotations];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSParameterAssert([object isKindOfClass:UCDPlace.class]);
    UCDPlace *place = object;
    UCDPlaceAnnotation *placeAnnotation = [self annotationForPlace:place];
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            if (placeAnnotation) {
                UCDPlaceAnnotation *placeAnnotation = [[UCDPlaceAnnotation alloc] initWithPlace:place];
                [self.mapView addAnnotation:placeAnnotation];
            }
            break;
        }
        case NSFetchedResultsChangeDelete: {
            if (placeAnnotation) {
                [self.mapView removeAnnotation:placeAnnotation];
            }
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            if (placeAnnotation) {
                [self.mapView removeAnnotation:placeAnnotation];
                [self.mapView addAnnotation:placeAnnotation];
            }
            break;
        }
    }
}
#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(UCDPlaceAnnotation *)annotation
{
    if ([annotation isKindOfClass:UCDPlaceAnnotation.class]) {
        MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:UCDMapViewControllerPlaceAnnotationReuseIdentifier];
        if (pinAnnotation == nil) {
            pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:UCDMapViewControllerPlaceAnnotationReuseIdentifier];
        }
        pinAnnotation.annotation = annotation;
        pinAnnotation.canShowCallout = YES;
        pinAnnotation.rightCalloutAccessoryView = [[UCDStyleManager sharedManager] disclosureButton];
        
        UCDPopularityView *popularityView = [[UCDStyleManager sharedManager] calloutPopularityView];
        popularityView.fill = ([annotation.place.peopleHere floatValue] / [self.maxPeopleHere floatValue]);
        pinAnnotation.leftCalloutAccessoryView = popularityView;
        
        return pinAnnotation;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UCDPlaceAnnotation *placeAnnotation = view.annotation;
    UCDPlaceViewController *placeViewController = [[UCDPlaceViewController alloc] initWithNibName:nil bundle:nil];
    placeViewController.place = placeAnnotation.place;
    __weak typeof(self) blockSelf = self;
    placeViewController.navigationItem.leftBarButtonItem = [[UCDStyleManager sharedManager] backBarButtonItemWithTitle:@"Back" action:^{
        [blockSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:placeViewController animated:YES];
}

@end
