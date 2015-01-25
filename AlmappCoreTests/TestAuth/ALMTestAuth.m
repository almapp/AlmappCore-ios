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

@end

@implementation ALMTestAuth

- (void)testAuth {
    XCTestExpectation *singleResourceExpectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    ALMSession *session = [[ALMSession alloc] init];
    
    session.resourceID = 1;
    session.email = @"pelopez2@uc.cl";
    session.password = @"randompassword";
    
    RLMRealm *realm = self.testRealm;
    [realm beginWriteTransaction];
    session = [ALMSession createOrUpdateInRealm:realm withObject:session];
    [realm commitWriteTransaction];
    
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.realm = self.testRealm;
        builder.session = [ALMSession sessionWithEmail:@"pelopez2@uc.cl" inRealm:builder.realm];
        builder.resourceClass = [ALMUser class];
        builder.customPath = @"me";
        
    } onLoad:^(id loadedResource) {
        
    } onFinish:^(NSURLSessionDataTask *task, id resource) {
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
