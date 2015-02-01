//
//  ALMChatManager.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FayeCpp/FayeCppClient.h>
#import <PromiseKit/PromiseKit.h>
#import <PromiseKit/Promise+When.h>

#import "ALMCoreModule.h"
#import "ALMChatManagerDelegate.h"
#import "ALMChatListenerDelegate.h"
#import "ALMCredential.h"
#import "ALMChat.h"

@interface ALMChatManager : ALMCoreModule <FayeCppClientDelegate>

@property (weak, nonatomic) id<ALMChatManagerDelegate> chatManagerDelegate;
@property (weak, nonatomic) id<ALMChatListenerDelegate> chatListenerDelegate;
@property (strong, nonatomic) NSMutableDictionary *extValues;
@property (assign, nonatomic) BOOL shouldLog;

- (id)init __attribute__((unavailable));
+ (instancetype)chatManagerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;

- (void)addClientWithCredential:(ALMCredential *)credential;
- (void)addClientWithCredential:(ALMCredential *)credential URL:(NSURL *)url;

- (PMKPromise *)connectWith:(ALMCredential *)credential;
- (PMKPromise *)disconnectWith:(ALMCredential *)credential;

- (PMKPromise *)subscribeToChats:(NSArray *)chats with:(ALMCredential *)credential;
- (PMKPromise *)subscribeToChat:(ALMChat *)chat with:(ALMCredential *)credential;

- (PMKPromise *)unsubscribeFromChats:(NSArray *)chats with:(ALMCredential *)credential;
- (PMKPromise *)unsubscribeFromChat:(ALMChat *)chat with:(ALMCredential *)credential;

- (PMKPromise *)sendMessage:(ALMChatMessage *)message to:(ALMChat *)chat with:(ALMCredential *)credential;

@end
