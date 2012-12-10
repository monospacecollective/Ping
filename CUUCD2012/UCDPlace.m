//
//  UCDPlace.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlace.h"

@implementation UCDPlace

@dynamic name;
@dynamic detail;
@dynamic latitude;
@dynamic longitude;
@dynamic accuracyRadius;
@dynamic rating;
@dynamic peopleHere;
@dynamic phone;
@dynamic website;
@dynamic user;


+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
}

- (CLLocationCoordinate2D)coordinate
{
    NSAssert(self.latitude && self.longitude, @"Requires latitude and longitude");
    return CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
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

- (NSString *)starRating
{
    NSInteger rating = nearbyintf(([self.rating floatValue] * 5));
    NSInteger emptyStars = 5.0 - rating;
    
    NSMutableString *starRating = [[NSMutableString alloc] init];
    
    for (int i = 0; i < rating; i++) {
        [starRating appendString:@"★"];
    }
    for (int i = 0; i < emptyStars; i++) {
        [starRating appendString:@"☆"];
    }
    
    return starRating;
}

- (NSString *)peopleHereDescripton
{
    return [NSString stringWithFormat:@"%d", [self.peopleHere integerValue]];
}

@end
