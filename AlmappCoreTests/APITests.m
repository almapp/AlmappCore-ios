//
//  APITests.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMTestsConstants.h"
#import "ALMUser.h"
#import "AlmappCore.h"

#import <Realm/Realm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import <AFNetworking/AFNetworking.h>
#import "ALMUsersController.h"
#import "ALMDummyCoreDelegated.h"

@interface APITests : XCTestCase

@end

@implementation APITests

- (void)setUp {
    [super setUp];
    [ALMCore initInstanceWithDelegate:[[ALMDummyCoreDelegated alloc] init] baseURL:[NSURL URLWithString:ALMBaseURL]];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInvalidClassRequest {
    ALMController* controller = [ALMCore controller];
    AFHTTPRequestOperation *op = [controller resourceForClass:[NSString class] id:1 parameters:nil onSuccess:^(id result) {
        
    } onFailure:^(NSError *error) {
        
    }];
    XCTAssertNil(op, @"Should not return an operation for invalid class input");
}

- (void)testRelectionAPIRequest {
    XCTestExpectation *singleResourceExpectation = [self expectationWithDescription:@"validGetSingleResource"];
    XCTestExpectation *multipleResourcesExpectation = [self expectationWithDescription:@"validGetMultipleResources"];

    ALMController* controller = [ALMCore controller];
    controller.saveToPersistenceStore = NO;
    
    
    AFHTTPRequestOperation *op1 = [controller resourceForClass:[ALMUser class] id:1 parameters:nil onSuccess:^(id result) {
        ALMUser *user = result;
        [singleResourceExpectation fulfill];
        NSLog(@"result: %@", user);
        XCTAssertNotNil(user, @"Must rertun obejct");
        
    } onFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [singleResourceExpectation fulfill];
    }];
    
    
    AFHTTPRequestOperation* op2 = [controller resourceCollectionForClass:[ALMUser class] parameters:nil onSuccess:^(NSArray *result) {
        
        [multipleResourcesExpectation fulfill];
        NSLog(@"result: %@", result);
        XCTAssertNotNil(result, @"Must rerturn a collection.");
        XCTAssertTrue(result.count != 0, @"Must contain at least one value");
        
    } onFailure:^(NSError *error) {
        
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [multipleResourcesExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [op1 cancel];
        [op2 cancel];
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
