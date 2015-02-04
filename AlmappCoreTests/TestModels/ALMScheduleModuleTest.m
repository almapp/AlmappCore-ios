//
//  ALMScheduleModuleTest.m
//  AlmappCore
//
//  Created by Patricio López on 04-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMResourceTest.h"

@interface ALMScheduleModuleTest : ALMResourceTest

@end

@implementation ALMScheduleModuleTest

- (void)testRelative {
    [self resources:[ALMScheduleModule class] path:nil params:nil onSuccess:^(RLMResults *resources) {
        ALMScheduleModule *m = [ALMScheduleModule moduleForDay:ALMScheduleDayFriday block:1 inRealm:self.testRealm];
        NSDate *futureDate = m.incomingStartTime;
        NSDate *closest = m.startTime;
        NSDate *now = [NSDate date];
        NSLog(@"now    : %@", now);
        NSLog(@"closest: %@", closest);
        NSLog(@"future : %@", futureDate);
        
        NSLog(@"");
    }];
}

@end
