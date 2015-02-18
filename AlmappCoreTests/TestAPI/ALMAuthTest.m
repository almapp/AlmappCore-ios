//
//  ALMAuthTest.m
//  AlmappCore
//
//  Created by Patricio López on 16-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMResourceTest.h"

@interface ALMAuthTest : ALMResourceTest

@end

@implementation ALMAuthTest

- (void)testAuth {
    NSString *email = nil;
    NSString *password = nil;
    XCTAssertTrue(email && password, @"Enter your data to test this method");
    
    NSString *description = [NSString stringWithFormat:@"LOGIN"];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    ALMUserController *controller = [ALMUserController controller];
    [controller login:email password:password realm:self.testRealm].then(^(ALMSession *session) {
        NSLog(@"%@", session);
        XCTAssertNotNil(session);
        XCTAssertNotNil(session.user);
        XCTAssertNotNil(session.credential);
        
        XCTAssertEqual(session.realm.path, self.testRealm.path);
        
        NSString *password = session.credential.password;
        XCTAssertTrue(password && password.length > 0);
        
        XCTAssertNotNil(session.user.careers.firstObject);
        
        [expectation fulfill];
        
    }).catch( ^(NSError *error) {
        NSLog(@"%@", error);
        XCTFail(@"Error Login in");
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
