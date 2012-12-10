//
//  UCDPlaceAnnotation.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/10/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlaceAnnotation.h"

@implementation UCDPlaceAnnotation

- (id)initWithPlace:(UCDPlace *)place
{
    self = [super init];
    if (self) {
        self.place = place;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return self.place.coordinate;
}

- (NSString *)title
{
    return self.place.name;
}

- (NSString *)subtitle
{
    return self.place.detail;
}

@end
