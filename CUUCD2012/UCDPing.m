//
//  UCDPing.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/10/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPing.h"
#import "UCDUser.h"


@implementation UCDPing

@dynamic accuracyRadius;
@dynamic latitude;
@dynamic longitude;
@dynamic time;
@dynamic user;

@dynamic coordinate;

- (NSString *)timeDescription
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:self.time];
}

- (CLLocation *)location
{
    NSAssert(self.latitude && self.longitude, @"Requires latitude and longitude");
    return [[CLLocation alloc] initWithLatitude:self.latitude.floatValue longitude:self.longitude.floatValue];
}

- (CLLocationCoordinate2D)coordinate
{
    NSAssert(self.latitude && self.longitude, @"Requires latitude and longitude");
    return CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.latitude = @(coordinate.latitude);
    self.longitude = @(coordinate.longitude);
}

@end
