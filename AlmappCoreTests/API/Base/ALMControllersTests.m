//
//  ALMControllersTests.m
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMTestCase.h"

@interface ALMControllersTests : ALMTestCase

@end

@implementation ALMControllersTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNilControllerClass {
    XCTAssertNil([ALMCore controller:nil], @"Must return nill for invalid input");
    XCTAssertNil([self.core controller:nil], @"Must return nill for invalid input");
    
    XCTAssertNotNil([ALMCore controller], @"must not be nil");
    XCTAssertNotNil([self.core controller], @"must not be nil");
    
    XCTAssertTrue([[[ALMCore controller:[ALMController class]] class] isSubclassOfClass:[ALMController class]], @"Must return a valid controller");
    XCTAssertTrue([[[self.core controller:[ALMController class]] class] isSubclassOfClass:[ALMController class]], @"Must return a valid controller");
    
    XCTAssertTrue([[ALMCore controller:[ALMWebPagesController class]] class] == [ALMWebPagesController class], @"Must return a valid controller");
    XCTAssertTrue([[self.core controller:[ALMWebPagesController class]] class] == [ALMWebPagesController class], @"Must return a valid controller");
    
    XCTAssertTrue([[[ALMCore controller:[ALMWebPagesController class]] class] isSubclassOfClass:[ALMController class]], @"Must return a valid controller");
    XCTAssertTrue([[[self.core controller:[ALMWebPagesController class]] class] isSubclassOfClass:[ALMController class]], @"Must return a valid controller");
}

- (void)testInvalidClassRequest {
    ALMController* controller = [ALMCore controller];
    AFHTTPRequestOperation *op = [controller resource:[NSString class] id:1 parameters:nil onSuccess:^(id result) {
        XCTFail(@"This not should be executed");
        
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
        XCTAssertNotNil(error, @"Must return an error");
        
    }];
    
    XCTAssertNil(op, @"Should not return an operation for invalid class input");
    
    op = [controller resourceCollection:[NSString class] parameters:nil onSuccess:^(NSArray *result) {
        XCTFail(@"This not should be executed");
        
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
        XCTAssertNotNil(error, @"Must return an error");
    }];
    
    XCTAssertNil(op, @"Should not return an operation for invalid class input");
}

@end
