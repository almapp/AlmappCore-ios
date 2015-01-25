//
//  ALMTestAuth.m
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMTestCase.h"

@interface ALMTestAuth : ALMTestCase

@property (readonly) ALMSession *session;

@end

@implementation ALMTestAuth

- (ALMSession *)session {
    ALMSession *session = [[ALMSession alloc] init];
    
    session.email = @"pelopez2@uc.cl";
    session.password = @"randompassword";
    
    RLMRealm *realm = self.testRealm;
    [realm beginWriteTransaction];
    session = [ALMSession createOrUpdateInRealm:realm withObject:session];
    [realm commitWriteTransaction];
    
    return session;
}

- (void)testLogin {
    XCTestExpectation *singleResourceExpectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    ALMSession *session = self.session;
    
    NSURLSessionDataTask *op = [self.requestManager loginWith:session onSuccess:^(NSURLSessionDataTask *task, ALMSession *session) {
        XCTAssertNotNil(session);
        XCTAssertTrue([NSThread isMainThread], @"Must be on main thread");
        NSLog(@"%@", session);
        [singleResourceExpectation fulfill];
        
    } onFail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [singleResourceExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        [op cancel];
    }];
}

- (void)testPrivateResource {
    XCTestExpectation *singleResourceExpectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    ALMSession *session = self.session;
    
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.realmPath = self.testRealmPath;
        builder.session = session;
        builder.resourceClass = [ALMUser class];
        builder.customPath = @"users/me";
        
    } onLoad:^(id loadedResource) {
        
    } onFinish:^(NSURLSessionDataTask *task, id resource) {
        XCTAssertNotNil(resource);
        NSLog(@"%@", resource);
        XCTAssertTrue([NSThread isMainThread], @"Must be on main thread");
        [singleResourceExpectation fulfill];
        
    } onError:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [singleResourceExpectation fulfill];
        
    }]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        [op cancel];
    }];
}

- (void)testMultipleRequests {
    XCTestExpectation *exp1 = [self expectationWithDescription:@"exp1"];
    XCTestExpectation *exp2 = [self expectationWithDescription:@"exp2"];
    XCTestExpectation *exp3 = [self expectationWithDescription:@"exp3"];
    
    ALMSession *session = self.session;
    
    NSURLSessionDataTask *op1 = [self.requestManager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.realmPath = self.testRealmPath;
        builder.session = session;
        builder.resourceClass = [ALMUser class];
        builder.customPath = @"users/me";
        
    } onLoad:^(id loadedResource) {
        
    } onFinish:^(NSURLSessionDataTask *task, id resource) {
        XCTAssertNotNil(resource);
        NSLog(@"%@", resource);
        XCTAssertTrue([NSThread isMainThread], @"Must be on main thread");
        [exp1 fulfill];
        
    } onError:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [exp1 fulfill];
        
    }]];
    
    NSURLSessionDataTask *op2 = [self.requestManager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.realmPath = self.testRealmPath;
        builder.session = session;
        builder.resourceClass = [ALMCampus class];
        builder.resourceID = 1;
        
    } onLoad:^(id loadedResource) {
        
    } onFinish:^(NSURLSessionDataTask *task, id resource) {
        XCTAssertNotNil(resource);
        NSLog(@"%@", resource);
        XCTAssertTrue([NSThread isMainThread], @"Must be on main thread");
        [exp2 fulfill];
        
    } onError:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [exp2 fulfill];
        
    }]];
    
    NSURLSessionDataTask *op3 = [self.requestManager GET:[ALMCollectionRequest request:^(ALMCollectionRequest *builder) {
        builder.realmPath = self.testRealmPath;
        builder.session = session;
        builder.resourceClass = [ALMFaculty class];
        
    } onLoad:^(RLMResults *loadedResources) {
        
    } onFinish:^(NSURLSessionDataTask *task, RLMResults *resources) {
        XCTAssertNotNil(resources);
        NSLog(@"Loaded #%lu", (unsigned long)resources.count);
        XCTAssertTrue([NSThread isMainThread], @"Must be on main thread");
        [exp3 fulfill];
        
    } onError:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [exp3 fulfill];
    }]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        [op1 cancel];
        [op2 cancel];
        [op3 cancel];
    }];
}

@end
