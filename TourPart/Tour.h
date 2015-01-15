//
//  Tour.h
//  TourPart
//
//  Created by Alex De Biasi on 14/01/15.
//  Copyright (c) 2015 Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Run, Step;

@interface Tour : NSManagedObject

@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *hasRuns;
@property (nonatomic, retain) NSSet *hasSteps;
@property (nonatomic, retain) Run *hasPath;
@end

@interface Tour (CoreDataGeneratedAccessors)

- (void)addHasRunsObject:(Run *)value;
- (void)removeHasRunsObject:(Run *)value;
- (void)addHasRuns:(NSSet *)values;
- (void)removeHasRuns:(NSSet *)values;

- (void)addHasStepsObject:(Step *)value;
- (void)removeHasStepsObject:(Step *)value;
- (void)addHasSteps:(NSSet *)values;
- (void)removeHasSteps:(NSSet *)values;

@end
