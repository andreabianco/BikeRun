//
//  Run.h
//  TourPart
//
//  Created by Alex De Biasi on 14/01/15.
//  Copyright (c) 2015 Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Tour;

@interface Run : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSSet *hasLocations;
@property (nonatomic, retain) Tour *isTour;
@end

@interface Run (CoreDataGeneratedAccessors)

- (void)addHasLocationsObject:(Location *)value;
- (void)removeHasLocationsObject:(Location *)value;
- (void)addHasLocations:(NSSet *)values;
- (void)removeHasLocations:(NSSet *)values;

@end
