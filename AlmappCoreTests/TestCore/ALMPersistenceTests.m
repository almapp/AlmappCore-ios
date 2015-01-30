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
    
    /*
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.resourceClass = [ALMUser class];
        builder.resourceID = 1;
        builder.realmPath = [self testRealmPath];
        
    } onLoad:^(id loadedResource) {
        XCTAssertNil(loadedResource, @"Should not exist");
        
    } onFinish:^(NSURLSessionDataTask *task, id resource) {
        XCTAssertNotNil(resource, @"Should exist");
        NSLog(@"%@", resource);
        
        XCTAssert([ALMUser allObjectsInRealm:[self testRealm]].count > 0, @"Must have at least one object");
        [[ALMCore sharedInstance] dropDefaultDatabase];
        XCTAssert([ALMUser allObjects].count == 0, @"All users should been deleted.");
        [singleResourceExpectation fulfill];
        
    } onError:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [singleResourceExpectation fulfill];
    }]];
    
    [self waitForExpectationsWithTimeout:7 handler:^(NSError *error) {
        [op cancel];
    }];
     */
}

@end
