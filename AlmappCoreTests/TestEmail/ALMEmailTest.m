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

@interface ALMEmailTest : ALMTestCase <ALMGmailDelegate>

@property (strong, nonatomic) ALMGmailManager *manager;

@end

@implementation ALMEmailTest

- (void)setUp {
    [super setUp];
    self.manager = [ALMGmailManager emailManager:self.testSession];
    self.manager.delegate = self;
}

- (void)testEmail {
    NSString *description = [NSString stringWithFormat:@"Gmail"];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    
    [self.manager fetchEmailsWithLabel:self.manager.inboxLabel].then( ^(ALMEmailLabel *label) {
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

+ (GTMOAuth2Authentication *)auth {
    return nil;
}

- (GTMOAuth2Authentication *)gmailAuthenticationFor:(ALMGmailManager *)manager {
    return [ALMEmailTest auth];
}

- (ALMApiKey *)gmailApiKey:(ALMGmailManager *)manager {
    NSAssert(2+2 == 5, @"Missing api key");
    return nil;
}

- (NSString *)gmailScope:(ALMGmailManager *)manager {
    return [GTMOAuth2Authentication scopeWithStrings:kGTLAuthScopeGmailCompose, kGTLAuthScopeGmailModify, nil];
}


@end
