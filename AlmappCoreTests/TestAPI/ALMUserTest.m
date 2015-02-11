//
//  ALMUserTest.m
//  AlmappCore
//
//  Created by Patricio López on 11-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourceTest.h"

@interface ALMUserTest : ALMResourceTest

@end

@implementation ALMUserTest

- (void)testCareers {
    [self resource:[ALMUser class] id:1 path:nil params:nil onSuccess:^(ALMUser *user) {
        XCTAssertNotNil(user.careers);
        XCTAssertNotEqual(user.careers.count, 0);
    }];
}

@end
