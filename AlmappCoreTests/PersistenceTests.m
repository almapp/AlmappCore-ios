//
//  PersistenceTests.m
//  AlmappCore
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMUser.h"
#import "ALMCore.h"
#import "ALMDummyCoreDelegated.h"
#import "ALMTestsConstants.h"

@interface PersistenceTests : XCTestCase

@end

@implementation PersistenceTests

- (void)setUp {
    [super setUp];
    [ALMCore initInstanceWithDelegate:[[ALMDummyCoreDelegated alloc] init] baseURL:[NSURL URLWithString:ALMBaseURL]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDatabaseDrop {
    XCTestExpectation *singleResourceExpectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    ALMController* controller = [ALMCore controller];
    
    
    AFHTTPRequestOperation *op1 = [controller resourceForClass:[ALMUser class] id:1 parameters:nil onSuccess:^(id result) {
        ALMUser *user = result;
        [singleResourceExpectation fulfill];
        NSLog(@"result: %@", user);
        XCTAssertNotNil(user, @"Must rertun obejct");
        
        XCTAssert([ALMUser allObjects].count > 0, @"Must have at least one object");
        
        [[ALMCore sharedInstance] dropDatabaseDefault];
        XCTAssert([ALMUser allObjects].count == 0, @"All users should been deleted.");
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [singleResourceExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:7 handler:^(NSError *error) {
        [op1 cancel];
    }];

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
