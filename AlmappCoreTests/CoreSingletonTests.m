//
//  CoreSingletonTests.m
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

@interface CoreSingletonTests : XCTestCase

@property (strong, nonatomic) ALMDummyCoreDelegated *dummy;
@property (strong) AlmappCore *core;

@end

@implementation CoreSingletonTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    _dummy = [[ALMDummyCoreDelegated alloc] init];
    if(_core == nil) {
        _core = [AlmappCore initInstanceWithDelegate:nil baseURL:nil];
        XCTAssertNil(_core, @"Cannot create singleton with invalid params");
        
        _core = [AlmappCore initInstanceWithDelegate:_dummy baseURL:nil];
        XCTAssertNil(_core, @"Cannot create singleton with invalid params");
        
        _core = [AlmappCore initInstanceWithDelegate:_dummy baseURL:[NSURL URLWithString:ALMBaseURL]];
        XCTAssertNotNil(_core, @"Cannot find AlmappCore instance for valid params");
        
        _core = nil;
        [AlmappCore setSharedInstance:nil];
        XCTAssertNil([AlmappCore sharedInstance], @"Singleton must not exist");
        
        _core = [AlmappCore initInstanceWithDelegate:_dummy baseURLString:ALMBaseURL];
        XCTAssertNotNil(_core, @"Cannot find AlmappCore instance for valid params with URL string");
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetAllOwnedUsers {
    XCTAssertNotNil([_core availableUsers], @"Must not be nil");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
