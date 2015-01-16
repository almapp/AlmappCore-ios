//
//  ALMPersistenceTests.m
//  AlmappCore
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMTestCase.h"

@interface ALMPersistenceTests : ALMTestCase

@end

@implementation ALMPersistenceTests

- (void)testDatabaseDrop {
    XCTestExpectation *singleResourceExpectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    ALMController* controller = [ALMCore controller];
    AFHTTPRequestOperation *op = [controller resource:[ALMUser class] id:1 parameters:nil onSuccess:^(id result) {
        ALMUser *user = result;
        [singleResourceExpectation fulfill];
        NSLog(@"result: %@", user);
        XCTAssertNotNil(user, @"Must return object");
        
        XCTAssert([ALMUser allObjects].count > 0, @"Must have at least one object");
        
        [[ALMCore sharedInstance] dropDatabaseDefault];
        XCTAssert([ALMUser allObjects].count == 0, @"All users should been deleted.");
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [singleResourceExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:7 handler:^(NSError *error) {
        [op cancel];
    }];
}

@end
