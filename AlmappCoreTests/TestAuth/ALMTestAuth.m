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

@end
