//
//  ALMScheduleModulesTests.m
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMResourcesTests.h"

@interface ALMScheduleModulesTests : ALMResourcesTests

@end

@implementation ALMScheduleModulesTests

- (void)testModules {
    [self resourceCollection:[ALMScheduleModule class] path:nil params:nil afterSuccess:^(NSArray *result) {
        NSArray *modules = result;
        XCTAssertNotNil(modules, @"Must exist");
        XCTAssertNotEqual(modules.count, 0, "Must not be empty");
        NSLog(@"%@", modules.firstObject);

        NSLog(@"%@", [ALMScheduleModule blocksOnDay:ALMScheduleDayMonday inRealm:[self testRealm]]);
        NSLog(@"%@", [ALMScheduleModule startTimesOnDay:ALMScheduleDayMonday inRealm:[self testRealm]]);
        NSLog(@"%@", [ALMScheduleModule endTimesOnDay:ALMScheduleDayMonday inRealm:[self testRealm]]);
    }];
}

- (void)testNeighbors {
    RLMRealm *testRealm = [self testRealm];
    
    ALMScheduleModule *first = [[ALMScheduleModule alloc] init];
    first.initials = @"1";
    first.dayNumber = ALMScheduleDayMonday;
    first.block = 1;
    first.resourceID = 1;
    
    [testRealm beginWriteTransaction];
    [testRealm addObject:first];
    [testRealm commitWriteTransaction];
    
    ALMScheduleModule *middle = [[ALMScheduleModule alloc] init];
    middle.initials = @"2";
    middle.dayNumber = ALMScheduleDayWednesday;
    middle.block = 2;
    middle.resourceID = 2;
    
    [testRealm beginWriteTransaction];
    [testRealm addObject:middle];
    [testRealm commitWriteTransaction];
    
    ALMScheduleModule *last = [[ALMScheduleModule alloc] init];
    last.initials = @"3";
    last.dayNumber = ALMScheduleDaySunday;
    last.block = 3;
    last.resourceID = 3;
    
    [testRealm beginWriteTransaction];
    [testRealm addObject:last];
    [testRealm commitWriteTransaction];
    
    first = [ALMScheduleModule objectInRealm:testRealm forID:1];
    middle = [ALMScheduleModule objectInRealm:testRealm forID:2];
    last = [ALMScheduleModule objectInRealm:testRealm forID:3];
    
    XCTAssertEqual(middle.resourceID, last.previousModule.resourceID);
    XCTAssertEqual(middle.resourceID, first.nextModule.resourceID);
    XCTAssertEqual(first.resourceID, last.nextModule.resourceID);
    XCTAssertEqual(last.resourceID, first.previousModule.resourceID);
}

@end
