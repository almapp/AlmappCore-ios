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
    
    [self.manager fetchEmailsInFolder:self.manager.inboxFolder].then( ^(id threads) {
        for (ALMEmailThread *thread in threads) {
            for (ALMEmail *email in thread.emails) {
                for (NSDictionary *address in @[email.from, email.to]) {
                    //NSLog(@"%@", address);
                    XCTAssertNotEqual(address.count, 0);
                }
                for (NSDictionary *address in @[email.cc, email.cco]) {
                    //NSLog(@"%@", address);
                }
            }
        }
        
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
