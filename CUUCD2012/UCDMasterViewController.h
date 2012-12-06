//
//  UCDMasterViewController.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UCDPaneViewControllerType) {
    UCDPaneViewControllerTypePlaces,
    UCDPaneViewControllerTypeSettings,
    UCDPaneViewControllerTypeCount,
};

@interface UCDMasterViewController : UITableViewController

@property (nonatomic, assign) UCDPaneViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSNavigationPaneViewController *navigationPaneViewController;

- (void)transitionToViewController:(UCDPaneViewControllerType)paneViewControllerType;

@end
