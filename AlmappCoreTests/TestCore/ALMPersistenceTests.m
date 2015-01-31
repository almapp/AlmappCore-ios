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
    
    [self.controller GET:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *r) {
        r.resourceClass = [ALMFaculty class];
        r.resourceID = 1;
        r.realmPath = [self testRealmPath];
        
        [r setOnFetchResource:^(ALMResource *resource, NSURLSessionDataTask *task) {
            XCTAssertNotNil(resource, @"Should exist");
            NSLog(@"%@", resource);
            
            XCTAssert([ALMFaculty allObjectsInRealm:[self testRealm]].count > 0, @"Must have at least one object");
            [[ALMCore sharedInstance] dropDefaultDatabase];
            XCTAssert([ALMFaculty allObjects].count == 0, @"All users should been deleted.");
            [singleResourceExpectation fulfill];
        }];
        [r setOnError:^(NSError *error, NSURLSessionDataTask *task) {
            NSLog(@"Error: %@", error);
            XCTFail(@"Error performing request.");
            [singleResourceExpectation fulfill];
        }];
        
    }]];
    
    [self waitForExpectationsWithTimeout:7 handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
