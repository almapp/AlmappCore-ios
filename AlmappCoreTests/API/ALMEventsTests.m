//
//  ALMEventsTests.m
//  AlmappCore
//
//  Created by Patricio López on 15-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourcesTests.h"

@interface ALMEventsTests : ALMResourcesTests

@end

@implementation ALMEventsTests

- (void)testEvents {
    [self resource:[ALMEvent class] ID:1 path:nil params:nil afterSuccess:^(id result) {
        ALMEvent *event = result;
        
        XCTAssertNotNil(event, @"Must rerturn a valid object.");
        XCTAssertNotNil(event.user, @"Must rerturn a valid nested object.");
        XCTAssertNotNil(event.host, @"Must rerturn a valid nested object.");
        
        XCTAssertEqualObjects(((ALMArea*)event.host).singleForm, [ALMCampus singleForm]);
        
        XCTAssertNotNil(event.participants, @"Must rerturn a valid nested collection.");
        XCTAssertEqual(event.participants.count, 2, @"Must has the correct number of people.");
    }];
}


@end
