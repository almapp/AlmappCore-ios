//
//  ALMTestSections.m
//  AlmappCore
//
//  Created by Patricio López on 26-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourceTest.h"

@interface ALMTestSections : ALMResourceTest

@end

@implementation ALMTestSections

- (void)testSection {
    [self nestedResources:[ALMSection class] as:nil on:[ALMCourse class] id:1 as:nil path:nil params:nil onSuccess:^(id parent, RLMResults *results) {
        for (ALMSection *section in results) {
            XCTAssertNotNil(section.course);
        }
    }];
}

- (void)testSectionCourse {
    [self resource:[ALMSection class] id:30 path:nil params:nil onSuccess:^(ALMSection* resource) {
        XCTAssertNotNil(resource.course);
    }];
    /*
    XCTestExpectation *expectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.realm = weakSelf.testRealm;
        builder.resourceClass = [ALMSection class];
        builder.resourceID =  1;
        
    } onLoad:^(ALMSection *loadedResource) {
        
    } onFinish:^(NSURLSessionDataTask *task, ALMSection *loadedResource) {
        XCTAssertNotNil(loadedResource);
        [expectation fulfill];
        
    } onError:[self errorBlock:expectation class:[ALMSection class]]]];
    
     [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        [op cancel];
    }];
*/
}

@end
