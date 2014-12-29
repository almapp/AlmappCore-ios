//
//  RestfulAPITests.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AlmappCore.h"
#import "ALMUtil.h"
#import "ALMDummyCoreDelegated.h"
#import "ALMUser.h"
#import "ALMTestsConstants.h"

@interface RestfulAPITests : XCTestCase

@end

@implementation RestfulAPITests

- (void)setUp {
    [super setUp];
    [AlmappCore initInstanceWithDelegate:[[ALMDummyCoreDelegated alloc] init] baseURL:[NSURL URLWithString:ALMBaseURL]];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"document open"];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ALMUser class]];
    
    // JSON : Model
    [mapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                  @"email": @"email",
                                                  @"username": @"username"
                                                  //@"publication_date": @"publicationDate"
                                                  }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"users"
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *manager = [AlmappCore sharedInstance].objectManager;
    [manager addResponseDescriptor:responseDescriptor];
    [manager getObjectsAtPath:@"api/v1/users/1"
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          NSArray* users = mappingResult.array;
                          XCTAssertNil(users);
                          // Possibly assert other things here about the document after it has opened...
                          
                          // Fulfill the expectation-this will cause -waitForExpectation
                          // to invoke its completion handler and then return.
                          [documentOpenExpectation fulfill];
                          
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                      }];
    
    // The test will pause here, running the run loop, until the timeout is hit
    // or all expectations are fulfilled.
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {

    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
