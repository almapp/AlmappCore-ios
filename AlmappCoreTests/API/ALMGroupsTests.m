//
//  ALMGroupsTests.m
//  AlmappCore
//
//  Created by Patricio López on 15-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourcesTests.h"

@interface ALMGroupsTests : ALMResourcesTests

@end

@implementation ALMGroupsTests

- (void)testGroups {
    [self resource:[ALMGroup class] ID:1 path:nil params:nil afterSuccess:^(id result) {
        ALMGroup *group = result;
        
        XCTAssertNotNil(group, @"Must rerturn a valid object.");
        
        XCTAssertNotNil(group.subscribers, @"Must rerturn a valid nested collection.");
        XCTAssertEqual(group.subscribers.count, 2, @"Must has the correct number of people.");
        
        ALMUser *user = [ALMUser objectInRealm:[self testRealm] forID:1];
        XCTAssertEqualObjects(user.subscribedGroups.firstObject, group, @"First should be subscribed to the group");
    }];
}

@end
