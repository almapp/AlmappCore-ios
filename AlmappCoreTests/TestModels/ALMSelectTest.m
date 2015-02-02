//
//  ALMSelectTest.m
//  AlmappCore
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourceTest.h"

@interface ALMSelectTest : ALMResourceTest

@end

@implementation ALMSelectTest

- (void)testSelect {
    [self resources:[ALMScheduleModule class] path:nil params:nil onSuccess:^(RLMResults *resources) {
        RLMResults *modulesOfDay = [ALMScheduleModule scheduleModulesOfDay:ALMScheduleDayMonday inRealm:self.testRealm];
        NSArray *ids = [modulesOfDay select:kRResourceID];
        NSLog(@"%@", ids);
        for (int i = 0; i < ids.count; ) {
            long moduleId = [ids[i] longValue];
            XCTAssertEqual(++i, moduleId);
        }
    }];
}

@end
