//
//  UCDAppDelegate.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UCDNotificationLocationManagerDidUpdate;

@class MSNavigationPaneViewController;
@class UCDUser;

@interface UCDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSNavigationPaneViewController *navigationPaneViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;

#if defined(DEBUG)
@property (readonly, strong, nonatomic) PDDebugger *debugger;
#endif

- (void)saveContext;

- (void)presentWelcomeView;
- (void)welcomeCompleteForUser:(UCDUser *)user;
- (void)signOut;

+ (UCDAppDelegate *)sharedAppDelegate;

- (UCDUser *)currentUserInContext:(NSManagedObjectContext *)context;
- (void)setCurrentUser:(UCDUser *)user;
- (void)removeCurrentUser;

@end
