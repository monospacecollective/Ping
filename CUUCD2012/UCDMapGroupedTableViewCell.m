//
//  UCDMapGroupedTableViewCell.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDMapGroupedTableViewCell.h"

NSString * const UCDMapReuseIdentifier = @"MapReuseIdentifier";

@interface UCDMapGroupedTableViewCell () <MKMapViewDelegate, MKAnnotation>

@end

@implementation UCDMapGroupedTableViewCell

#pragma mark - UIView

- (void)layoutSubviews
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.coordinate, 500.0, 500.0);
    [self.map setRegion:region animated:NO];
    CGRect mapFrame = CGRectInset(self.backgroundView.frame, 1.0, 1.0);
    mapFrame.origin.y = 0.0;
    self.map.frame = mapFrame;
    self.map.layer.cornerRadius = 7.0;
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.map = [[MKMapView alloc] init];
        self.map.userInteractionEnabled = NO;
        self.map.delegate = self;
        self.map.showsUserLocation = YES;
        [self.map addAnnotation:self];
        [self addSubview:self.map];
    }
    return self;
}

#pragma mark - UCDGroupedTableViewCell

+ (CGFloat)cellHeight
{
    return 132.0;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == self) {
        return [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:nil];
    } else {
        return nil;
    }
}

@end
