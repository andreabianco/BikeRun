//
//  BRMathOperation.h
//  BikeRun
//
//  Created by Alex De Biasi on 11/12/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRMathOperation : NSObject
+ (NSString *)stringifyDistance:(float)meters;

+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;

+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;

+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations;

@end
