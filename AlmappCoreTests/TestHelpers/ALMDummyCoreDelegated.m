//
//  ALMDummyCoreDelegated.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMDummyCoreDelegated.h"

@implementation ALMDummyCoreDelegated

-(void)startPerformingNetworkTask {
    NSLog(@"Performing network task");
}

-(void)stopPerformingNetworkTask {
    NSLog(@"Ended network task");
}

@end
