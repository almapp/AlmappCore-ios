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
    [AlmappCore initInstanceWithDelegate:[[ALMDummyCoreDelegated alloc] init] baseURL:[NSURL URLWithString:ALMBaseURL]].inTestingEnvironment = YES;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUserController {
    XCTestExpectation *expectation = [self expectationWithDescription:@"validGet"];
    
    ALMUsersController* controller = [[ALMUsersController alloc] init];
    AFHTTPRequestOperation* op = [controller resource:1 parameters:nil onSuccess:^(RLMObject *result) {
        [expectation fulfill];
        
        NSLog(@"result: %@", result);
        XCTAssertNotNil(result, @"Must rertun obejct");
    } onFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        [op cancel];
    }];
}

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"validGet"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *op = [manager GET:@"http://patiwi-mcburger-pro.local:3000/api/v1/users" parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            [realm beginWriteTransaction];
            [[RLMRealm defaultRealm] deleteAllObjects];
            NSArray *result = [ALMUser createOrUpdateInRealm:realm withJSONArray:array];
            [realm commitWriteTransaction];
            
            [expectation fulfill];
            
            NSLog(@"result: %@", result);
            XCTAssertNotNil(result, @"Must return an array");
            
        });
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        [op cancel];
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
