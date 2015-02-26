//
//  ALMPersistenceTests.m
//  AlmappCore
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMTestCase.h"

@interface ALMPersistenceTests : ALMTestCase

@end

@implementation ALMPersistenceTests

- (void)testDatabaseDrop {
    XCTestExpectation *singleResourceExpectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    [self.controller GETResource:[ALMFaculty class] id:1 parameters:nil realm:self.testRealm].then(^(id jsonResponse, NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        ALMFaculty *resource = responseObject;
        
        XCTAssertNotNil(resource, @"Should exist");
        NSLog(@"%@", resource);
        
        XCTAssert([ALMFaculty allObjectsInRealm:[self testRealm]].count > 0, @"Must have at least one object");
        [[ALMCore sharedInstance] dropDefaultDatabase];
        XCTAssert([ALMFaculty allObjects].count == 0, @"All users should been deleted.");
        [singleResourceExpectation fulfill];
    
    }).catch( ^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
        [singleResourceExpectation fulfill];

    });
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

@end
