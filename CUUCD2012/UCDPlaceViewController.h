//
//  UCDPlaceViewController.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDGroupedTableViewController.h"
#import "UCDPlace.h"

@interface UCDPlaceViewController : UCDGroupedTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UCDPlace *place;

@end
