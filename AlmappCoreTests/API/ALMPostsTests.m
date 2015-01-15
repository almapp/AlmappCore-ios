//
//  ALMPostsTests.m
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourcesTests.h"

@interface ALMPostsTests : ALMResourcesTests

@end

@implementation ALMPostsTests

- (void)testPosts {
    [self resource:[ALMPost class] ID:1 path:nil params:nil afterSuccess:^(id result) {
        ALMPost *post = result;
        
        XCTAssertNotNil(post, @"Must rerturn a valid object.");
        XCTAssertNotNil(post.user, @"Must rerturn a valid nested object.");
        XCTAssertNotNil(post.target, @"Must rerturn a valid nested object.");
        
        XCTAssertEqualObjects(post.target.singleForm, [ALMCampus singleForm]);
    }];
    
    [self resource:[ALMPost class] ID:3 path:nil params:nil afterSuccess:^(id result) {
        ALMPost *post = result;
        
        XCTAssertNotNil(post, @"Must rerturn a valid object.");
        XCTAssertNotNil(post.user, @"Must rerturn a valid nested object.");
        XCTAssertNotNil(post.target, @"Must rerturn a valid nested object.");
        
        XCTAssertEqualObjects(post.target.singleForm, [ALMAcademicUnity singleForm]);
    }];
    
    [self resource:[ALMPost class] ID:4 path:nil params:nil afterSuccess:^(id result) {
        ALMPost *post = result;
        
        XCTAssertNotNil(post, @"Must rerturn a valid object.");
        XCTAssertNotNil(post.user, @"Must rerturn a valid nested object.");
        XCTAssertNotNil(post.target, @"Must rerturn a valid nested object.");
        XCTAssertNotNil(post.localization, @"Must rerturn a valid nested object.");
        
        XCTAssertEqualObjects(post.target.singleForm, [ALMCampus singleForm]);
        XCTAssertEqualObjects(post.localization.identifier, @"ENF_219");
    }];
    
    [self resource:[ALMPost class] ID:5 path:nil params:nil afterSuccess:^(id result) {
        ALMPost *post = result;
        
        XCTAssertNotNil(post, @"Must rerturn a valid object.");
        XCTAssertNotNil(post.user, @"Must rerturn a valid nested object.");
        XCTAssertNotNil(post.target, @"Must rerturn a valid nested object.");
        XCTAssertNotNil(post.event, @"Must rerturn a valid nested object.");
        
        XCTAssertEqualObjects(post.target.singleForm, [ALMBuilding singleForm]);
        XCTAssertEqualObjects(post.event.title, @"Example Event");
    }];
}

@end
