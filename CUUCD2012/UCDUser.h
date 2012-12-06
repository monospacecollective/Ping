//
//  UCDUser.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/5/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UCDPing, UCDPlace;

@interface UCDUser : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * locationAccuracyRadius;
@property (nonatomic, retain) NSNumber * locationCollectionInterval;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSSet *favoritePlaces;
@property (nonatomic, retain) NSSet *pings;
@end

@interface UCDUser (CoreDataGeneratedAccessors)

- (void)addFavoritePlacesObject:(UCDPlace *)value;
- (void)removeFavoritePlacesObject:(UCDPlace *)value;
- (void)addFavoritePlaces:(NSSet *)values;
- (void)removeFavoritePlaces:(NSSet *)values;

- (void)addPingsObject:(UCDPing *)value;
- (void)removePingsObject:(UCDPing *)value;
- (void)addPings:(NSSet *)values;
- (void)removePings:(NSSet *)values;

@end
