//
//  UCDMapGroupedTableViewCell.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDGroupedTableViewCell.h"

extern NSString * const UCDMapReuseIdentifier;

@interface UCDMapGroupedTableViewCell : UCDGroupedTableViewCell

@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
