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

@interface CoreSingletonTests : XCTestCase

@property (strong, nonatomic) ALMDummyCoreDelegated *dummy;

@end

@implementation CoreSingletonTests

NSString* const TESTING_BASE_URL = @"http://patiwi-mcburger-pro.local:3000/api/v1/";

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    _dummy = [[ALMDummyCoreDelegated alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _dummy = nil;
}

- (void)testSingletonInit {
    AlmappCore *app = nil;
    
    app = [AlmappCore initInstanceWithDelegate:nil baseURL:nil];
    XCTAssertNil(app, @"Cannot create singleton with invalid params");
    
    app = [AlmappCore initInstanceWithDelegate:_dummy baseURL:nil];
    XCTAssertNil(app, @"Cannot create singleton with invalid params");
    
    app = [AlmappCore initInstanceWithDelegate:_dummy baseURL:[NSURL URLWithString:TESTING_BASE_URL]];
    XCTAssertNotNil(app, @"Cannot find AlmappCore instance for valid params");

    app = nil;
    [AlmappCore setSharedInstance:nil];
    XCTAssertNil([AlmappCore sharedInstance], @"Singleton must not exist");
    
    [AlmappCore initInstanceWithDelegate:_dummy baseURLString:TESTING_BASE_URL];
    XCTAssertNotNil([AlmappCore sharedInstance], @"Singleton not found for corrent init with string URL");
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
