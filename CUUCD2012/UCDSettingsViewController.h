//
//  UCDSettingsViewController.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDGroupedTableViewController.h"

@class UCDUser;

@interface UCDSettingsViewController : UCDGroupedTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UCDUser *user;

@end
