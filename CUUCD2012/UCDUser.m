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

+ (UCDUser *)currentUserInContext:(NSManagedObjectContext *)context
{
    UCDUser *user = [UCDUser MR_findFirstInContext:context];
    return user;
}

- (NSString *)accuracyRadiusDescription
{
    NSDictionary *accuracies = @{
        @(UCDUserAccuracyIntervalTenMeters) : @"10 meters",
        @(UCDUserAccuracyIntervalFiftyMeters) : @"50 meters",
        @(UCDUserAccuracyIntervalFiveHundredMeters) : @"500 meters",
        @(UCDUserAccuracyIntervalOneKilometer) : @"1 kilometer",
    };
    
    if ([accuracies objectForKey:self.locationAccuracyRadius]) {
        return [accuracies objectForKey:self.locationAccuracyRadius];
    } else {
        return [NSString stringWithFormat:@"%@", self.locationAccuracyRadius];
    }
}

- (NSString *)collectionIntervalDescription
{
    NSDictionary *intervals = @{
        @(UCDUserDurationIntervalMinute) : @"1 min",
        @(UCDUserDurationIntervalFiveMinutes) : @"5 min",
        @(UCDUserDurationIntervalThirtyMinutes) : @"30 min",
        @(UCDUserDurationIntervalHour) : @"1 hour",
    };
    
    if ([intervals objectForKey:self.locationCollectionInterval]) {
        return [intervals objectForKey:self.locationCollectionInterval];
    } else {
        return [NSString stringWithFormat:@"%@", self.locationCollectionInterval];
    }
}

@end
