//
//  ALMEmailTest.m
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMTestCase.h"

@interface ALMEmailTest : ALMTestCase

@property (strong, nonatomic) ALMGmailManager *manager;

@end

@implementation ALMEmailTest

- (void)setUp {
    [super setUp];
    self.manager = [ALMGmailManager emailManager:self.testSession];
    self.manager.scope = @"";
    // self.manager.apiKey = [ALMApiKey apiKeyWithClient:@"" secret:@""];
}

- (void)testTokenSending {
    NSString *description = [NSString stringWithFormat:@"Token_sending"];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    [self.manager.emailController saveAccessToken:@"ACCESS_TOKEN" refreshToken:@"REFRESH_TOKEN" code:@"CODE" expirationDate:[NSDate distantFuture] provider:@"GMAIL"].then( ^(ALMEmailToken *token) {
        XCTAssertNotNil(token, @"null token");
        XCTAssertNotNil(self.testSession.emailToken, @"null token");
        XCTAssertEqual([ALMEmailToken allObjectsInRealm:self.testRealm].count, 1);
        
        return [self.manager.emailController saveAccessToken:@"ACCESS_TOKEN" refreshToken:@"REFRESH_TOKEN" code:@"CODE" expirationDate:[NSDate distantFuture] provider:@"GMAIL"].then( ^(ALMEmailToken *newToken) {
            XCTAssertNotNil(newToken, @"null token");
            XCTAssertNotNil(self.testSession.emailToken, @"null token");
            XCTAssertEqual([ALMEmailToken allObjectsInRealm:self.testRealm].count, 1);
            
            [expectation fulfill];
        });
        
    }).catch( ^(NSError *error) {
        NSLog(@"%@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)testEmail {
    NSString *description = [NSString stringWithFormat:@"Gmail"];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    [self.manager fetchEmailsInFolder:self.manager.inboxFolder].then( ^(ALMEmailFolder *label) {
        NSLog(@"%@", label);
        [expectation fulfill];
    }).catch(^(NSError *error) {
        NSLog(@"%@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


@end
