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
    first.dayNumber = ALMScheduleDayMonday;
    first.block = 1;
    first.resourceID = 1;
    
    [testRealm beginWriteTransaction];
    [testRealm addObject:first];
    [testRealm commitWriteTransaction];
    
    ALMScheduleModule *second = [[ALMScheduleModule alloc] init];
    second.dayNumber = ALMScheduleDayMonday;
    second.block = 2;
    second.resourceID = 2;
    
    [testRealm beginWriteTransaction];
    [testRealm addObject:second];
    [testRealm commitWriteTransaction];
    
    ALMScheduleModule *middle = [[ALMScheduleModule alloc] init];
    middle.dayNumber = ALMScheduleDayWednesday;
    middle.block = 2;
    middle.resourceID = 3;
    
    [testRealm beginWriteTransaction];
    [testRealm addObject:middle];
    [testRealm commitWriteTransaction];
    
    ALMScheduleModule *last = [[ALMScheduleModule alloc] init];
    last.dayNumber = ALMScheduleDaySunday;
    last.block = 3;
    last.resourceID = 4;
    
    [testRealm beginWriteTransaction];
    [testRealm addObject:last];
    [testRealm commitWriteTransaction];
    
    first = [ALMScheduleModule objectInRealm:testRealm forID:1];
    second = [ALMScheduleModule objectInRealm:testRealm forID:2];
    middle= [ALMScheduleModule objectInRealm:testRealm forID:3];
    last = [ALMScheduleModule objectInRealm:testRealm forID:4];
    
    XCTAssertEqual(first.previousModule.resourceID, last.resourceID);
    XCTAssertNil(first.previousModuleOnSameDay);
    
    XCTAssertEqual(first.nextModule.resourceID, second.resourceID);
    XCTAssertEqual(first.nextModuleOnSameDay.resourceID, second.resourceID);
    
    XCTAssertEqual(last.nextModule.resourceID, first.resourceID);
    XCTAssertNil(last.nextModuleOnSameDay);
    
    XCTAssertEqual(first.nextModule.nextModule.nextModule.resourceID, last.resourceID);
    
    RLMResults *modules = [ALMScheduleModule scheduleModulesOfDay:first.day inRealm:testRealm];
    XCTAssertEqual(modules.count, 2);
    XCTAssertEqual(((ALMScheduleModule*)modules[0]).resourceID, first.resourceID);
    XCTAssertEqual(((ALMScheduleModule*)modules[1]).resourceID, second.resourceID);
}

@end
