//
//  BRSharedVariables.h
//  BikeRun
//
//  Created by Alex De Biasi on 18/11/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRSharedVariables : NSObject{
    NSMutableArray *destList;
}

@property(nonatomic, strong)   NSMutableArray *destList;
@property Boolean filled;

+(id)sharedVariablesManager;

@end
