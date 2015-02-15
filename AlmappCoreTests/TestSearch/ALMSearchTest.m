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
    
    [self.controller SEARCH:@"IIC" ofType:[ALMCourse class]].then(^(id result, NSURLSessionDataTask *task) {
        NSLog(@"%@", result);
        [expectation fulfill];
        
    }).catch(^(NSError *error) {
        NSLog(@"%@", error);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
