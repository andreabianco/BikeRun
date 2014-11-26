//
//  BRSharedVariables.m
//  BikeRun
//
//  Created by Alex De Biasi on 18/11/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRSharedVariables.h"

@implementation BRSharedVariables

@synthesize destList;
@synthesize filled;

+(id)sharedVariablesManager {
    static BRSharedVariables *sharedVariablesClass = nil;
    @synchronized(self) {
        if (sharedVariablesClass == nil) {
            sharedVariablesClass = [[self alloc] init];
        }
    }
    return sharedVariablesClass;
}

-(id)init {
    if (self = [super init]) {
       destList = [[NSMutableArray alloc] init];
        filled= NO;
    }
    return self;
}

-(void)setdestList:(NSMutableArray*) lista{
    destList=lista;
}

-(void)dealloc {
}

@end