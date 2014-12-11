//
//  BRRun.h
//  BikeRun
//
//  Created by Alex De Biasi on 11/12/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRLocation; //need to compile, avoid circular linking between the 2 object

@interface BRRun : NSObject //replace with NSmanagedObject for CoreData
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSOrderedSet *locations;
@end

@interface BRRun (CoreDataGeneratedAccessors) //this part must be generated automatically from the wizard of CoreData..

- (void)insertObject:(BRLocation *)value inLocationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLocationsAtIndex:(NSUInteger)idx;
- (void)insertLocations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLocationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLocationsAtIndex:(NSUInteger)idx withObject:(BRLocation *)value;
- (void)replaceLocationsAtIndexes:(NSIndexSet *)indexes withLocations:(NSArray *)values;
- (void)addLocationsObject:(BRLocation *)value;
- (void)removeLocationsObject:(BRLocation *)value;
- (void)addLocations:(NSOrderedSet *)values;
- (void)removeLocations:(NSOrderedSet *)values;
@end

