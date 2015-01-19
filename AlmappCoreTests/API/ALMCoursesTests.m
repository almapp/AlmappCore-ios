//
//  ALMCoursesTests.m
//  AlmappCore
//
//  Created by Patricio López on 19-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMResourcesTests.h"

@interface ALMCoursesTests : ALMResourcesTests

@end

@implementation ALMCoursesTests

- (void)testCourses {
    [self resource:[ALMCourse class] ID:1 path:nil params:nil afterSuccess:nil];
    [self nestedResourceCollection:[ALMCourse class] on:[ALMFaculty class] withID:2 params:nil afterSuccess:nil];
}

- (void)testSections {
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"validNestedCollection_%@", @"Sections"]];
    
    ALMSectionsController* controller = [self getController:[ALMSectionsController class]];
    
    ALMResourcesTests * __weak weakSelf = self;
    
    AFHTTPRequestOperation* op = [controller sectionsInThisPeriodForCourseWithID:30 onSuccess:^(id course, NSArray *sections) {
        weakSelf.defaultNestedSuccessBlock(course, sections);
        [expectation fulfill];
    } onFailure:^(NSError *error) {
        
        NSLog(@"Resource Class: %@ | error: %@", [ALMSection class], error);
        XCTFail(@"Error performing request.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [op cancel];
    }];

}

@end
