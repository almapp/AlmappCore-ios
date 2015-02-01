//
//  ALMChatTest.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMTestCase.h"

@interface ALMChatTest : ALMTestCase

@property (strong, nonatomic) ALMChatManager *chatManager;
@property (strong, nonatomic) ALMChatManagerBlock *chatBlock;
@property (strong, nonatomic) ALMCredential *credential;
@property (strong, nonatomic) ALMChat *chat;

@end

@implementation ALMChatTest

- (void)setUp {
    [super setUp];
    self.chatManager = [self.core chatManager];
    self.chatBlock = [[ALMChatManagerBlock alloc] init];
    self.chatManager.chatListenerDelegate = self.chatBlock;
    self.credential = [self testSession].credential;
}

- (ALMChat *)chat {
    if (!_chat) {
        _chat = [[ALMChat alloc] init];
        _chat.resourceID = 1;
    }
    return _chat;
}

- (void)testChat {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test chat"];

    [_chatBlock setOnError:^(NSError *error) {
        NSLog(@"%@", error);
        [expectation fulfill];
    }];
    [_chatBlock setOnConnectedWith:^(ALMCredential *credential) {
        NSLog(@"%@", credential);
    }];
    [_chatBlock setOnSubscribedTo:^(ALMChat *chat, ALMCredential *credential) {
        NSLog(@"%@", chat);
    }];
    [_chatBlock setOnMessageSent:^(ALMChatMessage *message) {
        NSLog(@"%@", message);
        [expectation fulfill];
    }];
    [_chatBlock setOnMessageRecieve:^(ALMChatMessage *message) {
        NSLog(@"%@", message);
    }];
    
    [_chatManager addClientWithCredential:_credential];
    //[_chatManager connectWith:_credential];
    //[_chatManager subscribeToChat:self.chat with:_credential];
    [_chatManager sendMessage:nil to:self.chat with:_credential];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
