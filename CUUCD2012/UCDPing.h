//
//  UCDPing.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/10/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UCDUser;

@interface UCDPing : NSManagedObject

@property (nonatomic, retain) NSNumber * accuracyRadius;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) UCDUser *user;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
- (CLLocation *)location;

- (NSString *)timeDescription;
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate;

@end
