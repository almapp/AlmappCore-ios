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
    
    [self.controller FETCH:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *r) {
        r.resourceClass = [NSString class];
        
    } onLoad:^(id result) {
        XCTFail(@"This not should be executed");
        
    } onFetch:^(id result, NSURLSessionDataTask *task) {
        XCTFail(@"This not should be executed");
        
    } onError:^(NSError *error, NSURLSessionDataTask *task) {
        NSLog(@"%@", error);
        XCTAssertNotNil(error, @"Must return an error");
    }]];
}

@end
