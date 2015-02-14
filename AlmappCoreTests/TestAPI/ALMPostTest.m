//
//  ALMPostTest.m
//  AlmappCore
//
//  Created by Patricio López on 14-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMResourceTest.h"

@interface ALMPostTest : ALMResourceTest

@end

@implementation ALMPostTest

- (void)testPost {
    
    ALMPost *post = [[ALMPost alloc] init];
    post.content = @"Hola que hace";
    
    [self POST:post path:nil credential:[self testSession].credential onSuccess:^(id result) {
        NSLog(@"%@", result);
    }];
}

@end
