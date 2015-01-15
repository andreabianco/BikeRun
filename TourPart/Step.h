//
//  Step.h
//  TourPart
//
//  Created by Alex De Biasi on 14/01/15.
//  Copyright (c) 2015 Andrea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Tour;

@interface Step : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) Location *hasLocation;
@property (nonatomic, retain) Tour *isTour;

@end
