//
//  UCDAppDelegate.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSNavigationPaneViewController;

@interface UCDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSNavigationPaneViewController *navigationPaneViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (void)presentWelcomeView;
- (void)welcomeComplete;
- (void)signOut;

+ (UCDAppDelegate *)sharedAppDelegate;

@end
