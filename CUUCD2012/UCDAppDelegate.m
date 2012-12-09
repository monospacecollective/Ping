//
//  UCDAppDelegate.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDAppDelegate.h"
#import "CUUCD2012IncrementalStore.h"
#import "UCDMasterViewController.h"
#import "UCDUser.h"
#import "UCDWelcomeViewController.h"

NSString * const UCDNotificationLocationManagerDidUpdate = @"LocationManagerDidUpdate";

@interface UCDAppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) id currentUserObserver;
@property (nonatomic, strong) NSString *persistentStoreIdentifier;

- (void)updateCurrentUserForPersistentStore:(NSPersistentStore *)persistentStore;

@end

@implementation UCDAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize locationManager = _locationManager;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    self.navigationPaneViewController = [[MSNavigationPaneViewController alloc] init];
    
    UCDMasterViewController *masterViewController = [[UCDMasterViewController alloc] init];
    masterViewController.navigationPaneViewController = self.navigationPaneViewController;
    
    self.navigationPaneViewController.masterViewController = masterViewController;
    
    if ([self currentUserInContext:self.managedObjectContext] == nil) {
        [self presentWelcomeView];
    } else {
        [masterViewController transitionToViewController:UCDPaneViewControllerTypePlaces];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationPaneViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CUUCD2012" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[_persistentStoreCoordinator addPersistentStoreWithType:[CUUCD2012IncrementalStore type] configuration:nil URL:nil options:nil error:nil];
    [self updateCurrentUserForPersistentStore:incrementalStore];
    
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"CUUCD2012.sqlite"];
    
    NSDictionary *options = @{
        NSInferMappingModelAutomaticallyOption : @(YES),
        NSMigratePersistentStoresAutomaticallyOption: @(YES)
    };
    
    NSError *error = nil;
    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - UCDAppDelegate

+ (UCDAppDelegate *)sharedAppDelegate
{
    return (UCDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)presentWelcomeView
{
    UCDWelcomeViewController *welcomeViewController = [[UCDWelcomeViewController alloc] initWithNibName:nil bundle:nil];
    welcomeViewController.managedObjectContext = self.managedObjectContext;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    [self.navigationPaneViewController setPaneViewController:navigationController animated:YES completion:^{
        self.navigationPaneViewController.paneView.draggingEnabled = NO;
    }];
}


- (void)welcomeCompleteForUser:(UCDUser *)user;
{
    [self setCurrentUser:user];
    NSLog(@"Welcome complete for user %@", user);
    
    UCDMasterViewController *masterViewController = (UCDMasterViewController *)self.navigationPaneViewController.masterViewController;
    [masterViewController transitionToViewController:UCDPaneViewControllerTypePlaces];
    self.navigationPaneViewController.paneView.draggingEnabled = YES;
}

- (void)signOut
{
    [[self currentUserInContext:self.managedObjectContext] deleteInContext:self.managedObjectContext];
    [self.managedObjectContext MR_saveWithErrorCallback:nil];
    [self removeCurrentUser];
    _locationManager = nil;
    [self presentWelcomeView];
}

- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = 1.0;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        NSLog(@"Instantiated location manager");
    }
    return _locationManager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UCDNotificationLocationManagerDidUpdate object:manager];
}

#pragma mark - Current User

- (void)updateCurrentUserForPersistentStore:(NSPersistentStore *)persistentStore
{
    NSString *currentUserObjectID = [[NSUserDefaults standardUserDefaults] objectForKey:UCDDefaultsCurrentUserObjectID];
    if (currentUserObjectID == nil) {
        return;
    }
    NSScanner *scanner = [NSScanner scannerWithString:currentUserObjectID];
    [scanner scanUpToString:@"/User" intoString:nil];
    NSString *objectID = [[scanner string] substringFromIndex:[scanner scanLocation]];
    currentUserObjectID = [NSString stringWithFormat:@"x-coredata://%@%@", [persistentStore identifier], objectID];
    [[NSUserDefaults standardUserDefaults] setObject:currentUserObjectID forKey:UCDDefaultsCurrentUserObjectID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UCDUser *)currentUserInContext:(NSManagedObjectContext *)context
{
    NSString *currentUserObjectID = [[NSUserDefaults standardUserDefaults] objectForKey:UCDDefaultsCurrentUserObjectID];
    if (!currentUserObjectID) {
        return nil;
    }
    NSManagedObjectID *managedObjectID = [[context persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:currentUserObjectID]];
    if (!managedObjectID) {
        return nil;
    }
    UCDUser *user = (UCDUser *)[context existingObjectWithID:managedObjectID error:nil];
    NSParameterAssert([user isKindOfClass:UCDUser.class]);
    return user;
}

- (void)removeCurrentUser
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.currentUserObserver];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UCDDefaultsCurrentUserObjectID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCurrentUser:(UCDUser *)user
{
    NSParameterAssert([user isKindOfClass:UCDUser.class]);
    
    void(^updateCurrentUserObjectID)(UCDUser *user) = ^(UCDUser *user) {
        NSString *currentUserObjectID = [[user.objectID URIRepresentation] absoluteString];
        [[NSUserDefaults standardUserDefaults] setObject:currentUserObjectID forKey:UCDDefaultsCurrentUserObjectID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    
    self.currentUserObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext queue:NULL usingBlock:^(NSNotification *notification) {
        for (NSManagedObject *object in [notification.userInfo objectForKey:NSUpdatedObjectsKey]) {
            if ([object isKindOfClass:UCDUser.class]) {
                updateCurrentUserObjectID((UCDUser *)object);
            }
        }
    }];
    
    [self.managedObjectContext obtainPermanentIDsForObjects:@[user] error:nil];
    updateCurrentUserObjectID(user);
}

@end
