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
    //self.manager.apiKey = [ALMApiKey apiKeyWithClient:@"" secret:@""];
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
    
    [self.manager fetchThreadsWithEmailsLabeled:ALMEmailLabelInbox count:10].then( ^(NSArray *threads, NSArray *errorObjets, NSString *nextPageToken) {
        for (ALMEmailThread *thread in threads) {
            for (ALMEmail *email in thread.emails) {
                for (NSDictionary *address in @[email.from, email.to]) {
                    //NSLog(@"%@", address);
                    XCTAssertNotEqual(address.count, 0);
                }
                //for (NSDictionary *address in @[email.cc, email.cco]) {
                    //NSLog(@"%@", address);
                //}
            }
        }
        
        return PMKManifold(threads, nextPageToken);
        
    }).then( ^(id threads, NSString *pageToken) {
        return [self.manager fetchThreadsWithEmailsLabeled:ALMEmailLabelInbox count:10 pageToken:pageToken].then( ^(NSArray *newThreads, NSArray *errorObjets, NSString *nextPageToken) {
            
            NSArray *inboxThreads = self.manager.inboxFolder;
            XCTAssertEqual(inboxThreads.count, 20);
            
            for (ALMEmailThread *thread in threads) {
                for (ALMEmailThread *newThread in newThreads) {
                    XCTAssertNotEqualObjects(thread.identifier, newThread.identifier);
                }
            }
            return inboxThreads;
        });
        
    }).then( ^(NSArray *threads) {
        ALMEmailThread *thread = threads.lastObject;
        return [self.manager markThreadAsReaded:thread readed:YES].then( ^(NSArray *emails, NSArray *errorObjets) {
            XCTAssertEqual(emails.count, 1);
            XCTAssertEqual(errorObjets.count, 0);
            
            ALMEmail *email = emails.firstObject;
            
            XCTAssertFalse((email.labels & ALMEmailLabelUnread) == ALMEmailLabelUnread);
            
            return [self.manager markThreadAsReaded:thread readed:NO].then( ^(NSArray *newEmails, NSArray *errorObjets) {
                XCTAssertEqual(newEmails.count, 1);
                XCTAssertEqual(errorObjets.count, 0);
                
                ALMEmail *email = newEmails.firstObject;
                XCTAssertTrue((email.labels & ALMEmailLabelUnread) == ALMEmailLabelUnread);
                
                return newEmails;
            });
        });
        
    }).then( ^{
        [self.manager.emailController saveLastThreads:5 labeled:ALMEmailLabelInbox];
        
        ALMEmailThread *newest = self.manager.inboxFolder.firstObject;
        
        XCTAssertEqual(self.manager.inboxFolder.count, 5);
        
        XCTAssertEqualObjects(newest.identifier, [self.manager.inboxFolder.firstObject identifier]);
        
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
