//
//  ALMCoreSingletonTests.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AlmappCore.h"
#import "ALMCoreDelegate.h"
#import "ALMUtil.h"
#import "ALMTestsConstants.h"

@interface ALMCoreSingletonTests : XCTestCase <ALMCoreDelegate>

@end

@implementation ALMCoreSingletonTests

- (void)setUp {
    
}

- (ALMCore *)getCore {
    [ALMCore setSharedInstance:nil];
    
    return [ALMCore coreWithDelegate:self baseURL:[NSURL URLWithString:kTestingBaseURL] apiVersion:kTestingApiVersion apiKey:[ALMTestsConstants testingApiKey] organization:kTestingOrganization];
}

- (void)testSetup {
    ALMCore *core = [ALMCore coreWithDelegate:nil baseURL:nil apiKey:[ALMTestsConstants testingApiKey] organization:kTestingOrganization];
    XCTAssertNil(core, @"Cannot create singleton with invalid params");
    
    core = [ALMCore coreWithDelegate:self baseURL:nil apiKey:[ALMTestsConstants testingApiKey] organization:kTestingOrganization];
    XCTAssertNil(core, @"Cannot create singleton with invalid params");
    
    core = [ALMCore coreWithDelegate:self baseURL:[NSURL URLWithString:kTestingBaseURL] apiKey:[ALMTestsConstants testingApiKey] organization:kTestingOrganization];
    XCTAssertNotNil(core, @"Cannot find AlmappCore instance for valid params");
    
    core = nil;
    [ALMCore setSharedInstance:nil];
    XCTAssertNil([ALMCore sharedInstance], @"Singleton must not exist");
}

- (void)testMissingApiKey {
    [ALMCore setSharedInstance:nil];
    ALMCore *core = [ALMCore coreWithDelegate:self baseURL:[NSURL URLWithString:kTestingBaseURL] apiKey:nil  organization:kTestingOrganization];
    XCTAssertThrows(core.apiKey, @"Must throw exception");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


@end
