//
//  ALMSearchTest.m
//  AlmappCore
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMTestCase.h"

@interface ALMSearchTest : ALMTestCase

@end

@implementation ALMSearchTest

- (void)testSearch {
    NSString *description = [NSString stringWithFormat:@"SEARCH"];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    __weak typeof(self) weakSelf = self;
    
    [self.controller SEARCH:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *builder) {
        builder.resourceClass = [ALMCourse class];
        builder.realmPath = [weakSelf testRealmPath];
        builder.credential = [weakSelf testSession].credential;
        builder.shouldLog = YES;
        
    } onLoad:^(id result) {
        
    } onFetch:^(id result, NSURLSessionDataTask *task) {
        NSLog(@"%@", result);
        [expectation fulfill];
        
    } onError:^(NSError *error, NSURLSessionDataTask *task) {
        NSLog(@"%@", error);
        [expectation fulfill];
        
    }] query:@"IIC"];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
