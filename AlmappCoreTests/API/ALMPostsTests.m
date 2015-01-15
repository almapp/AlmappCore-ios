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
        
        XCTAssertNotNil(post, @"Must rerturn a valid parent object.");
        XCTAssertNotNil(post.user, @"Must rerturn a valid parent object.");
        XCTAssertNotNil(post.target, @"Must rerturn a valid parent object.");
        
        XCTAssertEqualObjects(post.target.singleForm, [ALMCampus singleForm]);
    }];
    
    
}

@end
