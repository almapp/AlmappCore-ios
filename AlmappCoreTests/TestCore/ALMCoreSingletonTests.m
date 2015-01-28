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
#import "ALMDummyCoreDelegated.h"
#import "ALMTestsConstants.h"

@interface ALMCoreSingletonTests : XCTestCase

@property (strong, nonatomic) ALMDummyCoreDelegated *dummy;

@end

@implementation ALMCoreSingletonTests

- (void)setUp {
    
}

- (ALMCore *)getCore {
    _dummy = [[ALMDummyCoreDelegated alloc] init];
    [ALMCore setSharedInstance:nil];
    
    return [ALMCore initInstanceWithDelegate:_dummy baseURLString:kTestingBaseURL apiKey:kTestingApiKey];
}

- (void)testSetup {
    _dummy = [[ALMDummyCoreDelegated alloc] init];
    
    ALMCore *core = [ALMCore initInstanceWithDelegate:nil baseURL:nil apiKey:kTestingApiKey];
    XCTAssertNil(core, @"Cannot create singleton with invalid params");
    
    core = [ALMCore initInstanceWithDelegate:_dummy baseURL:nil apiKey:kTestingApiKey];
    XCTAssertNil(core, @"Cannot create singleton with invalid params");
    
    core = [ALMCore initInstanceWithDelegate:_dummy baseURL:[NSURL URLWithString:kTestingBaseURL] apiKey:kTestingApiKey];
    XCTAssertNotNil(core, @"Cannot find AlmappCore instance for valid params");
    
    core = nil;
    [ALMCore setSharedInstance:nil];
    XCTAssertNil([ALMCore sharedInstance], @"Singleton must not exist");
    
    core = [ALMCore initInstanceWithDelegate:_dummy baseURLString:kTestingBaseURL apiKey:kTestingApiKey];
    XCTAssertNotNil(core, @"Cannot find AlmappCore instance for valid params with URL string");
}

- (void)testRequestManager {
    ALMCore *core = self.getCore;
    XCTAssertNotNil([core requestManager], @"Must not be null");
    
}

- (void)testMissingApiKey {
    _dummy = [[ALMDummyCoreDelegated alloc] init];
    [ALMCore setSharedInstance:nil];
    
    ALMCore *core = [ALMCore initInstanceWithDelegate:_dummy baseURLString:kTestingBaseURL apiKey:nil];
    XCTAssertThrows(core.apiKey, @"Must throw exception");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


@end
