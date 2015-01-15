//
//  Location.h
//  TourPart
//
//  Created by Alex De Biasi on 14/01/15.
//  Copyright (c) 2015 Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Run, Step;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * latitudine;
@property (nonatomic, retain) NSNumber * longitudine;
@property (nonatomic, retain) NSNumber * posStep;
@property (nonatomic, retain) Run *isRun;
@property (nonatomic, retain) Step *isStep;

@end
