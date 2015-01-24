//
//  ALMManagerTests.m
//  AlmappCore
//
//  Created by Patricio López on 24-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMTestCase.h"

@interface ALMManagerTests : ALMTestCase

@end

@implementation ALMManagerTests

- (void)testInvalidClassRequest {
    ALMRequestManager* manager = [self requestManager];
    [manager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.resourceClass = [NSString class];
        
    } onLoad:^(ALMResource *loadedResource) {
        XCTFail(@"This not should be executed");
        
    } onFinish:^(ALMResource *resource) {
        XCTFail(@"This not should be executed");
        
    } onError:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        XCTAssertNotNil(error, @"Must return an error");
        
    }]];
}

@end
