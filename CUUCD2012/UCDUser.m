//
//  UCDUser.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDUser.h"
#import "UCDPlace.h"


@implementation UCDUser

@dynamic birthday;
@dynamic email;
@dynamic gender;
@dynamic locationAccuracyRadius;
@dynamic locationCollectionInterval;
@dynamic occupation;
@dynamic favoritePlaces;
@dynamic pings;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
}


@end
