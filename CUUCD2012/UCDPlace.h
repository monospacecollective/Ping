//
//  UCDPlace.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

@interface UCDPlace : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * accuracyRadius;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) UCDPlace *user;

- (CLLocation *)location;
- (CLLocationCoordinate2D)coordinate;
- (CGFloat)distanceFromPlace:(UCDPlace *)place;
- (CGFloat)distanceFromLocation:(CLLocation *)place;
- (NSString *)starRating;

@end
