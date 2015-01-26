//
//  ALMScheduleItemTest.m
//  AlmappCore
//
//  Created by Patricio López on 26-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourceTest.h"

@interface ALMScheduleItemTest : ALMResourceTest

@end

@implementation ALMScheduleItemTest

- (void)testScheduleItems {
    [self resources:[ALMScheduleItem class] path:@"sections/1/schedule_items" params:nil onSuccess:^(RLMResults *resources) {
        XCTAssertNotNil(resources, @"Must rerturn a valid collection");
        XCTAssertNotEqual(resources.count, 0);
        
    }];
}

@end
