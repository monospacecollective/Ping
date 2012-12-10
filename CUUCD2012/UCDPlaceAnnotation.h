//
//  UCDPlaceAnnotation.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/10/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDPlace.h"

@interface UCDPlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, weak) UCDPlace* place;

- (id)initWithPlace:(UCDPlace *)place;

@end
