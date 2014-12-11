//
//  BRLocation.h
//  BikeRun
//
//  Created by Alex De Biasi on 11/12/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class BRRun;

@interface BRLocation : NSObject //this must changed into NSManagedObject for CoreData
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber *ids; //unique id to facilitate start and stop process (research based on id)
@property (nonatomic, retain) NSNumber *waypoint;//track the next waypoint to identify various step
@property (nonatomic, retain) BRRun *run;
@end
