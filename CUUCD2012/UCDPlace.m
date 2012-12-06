//
//  UCDPlace.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlace.h"
#import "UCDPlace.h"

@implementation UCDPlace

@dynamic name;
@dynamic detail;
@dynamic latitude;
@dynamic longitude;
@dynamic accuracyRadius;
@dynamic user;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
}

- (CLLocation *)location
{
    NSAssert(self.latitude && self.longitude, @"Requires latitude and longitude");
    return [[CLLocation alloc] initWithLatitude:self.latitude.floatValue longitude:self.longitude.floatValue];
}

- (CGFloat)distanceFromPlace:(UCDPlace *)place
{
    CGFloat dLatitude = (self.latitude.floatValue - place.latitude.floatValue);
    CGFloat dLongitude = (self.longitude.floatValue - place.longitude.floatValue);
    return sqrt(dLatitude*dLatitude + dLongitude*dLongitude );
}

- (CGFloat)distanceFromLocation:(CLLocation *)location
{
    CGFloat dLatitude = (self.latitude.floatValue - location.coordinate.latitude);
    CGFloat dLongitude = (self.longitude.floatValue - location.coordinate.longitude);
    return sqrt(dLatitude*dLatitude + dLongitude*dLongitude );
}

@end
