//
//  ALMChatManager.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FayeCpp/FayeCppClient.h>

#import "ALMCoreModule.h"
#import "ALMChatManagerDelegate.h"
#import "ALMSession.h"
#import "ALMChat.h"

@interface ALMChatManager : ALMCoreModule <FayeCppClientDelegate>

@property (weak, nonatomic) id<ALMChatManagerDelegate> chatManagerDelegate;
@property (assign, nonatomic) BOOL shouldLog;

- (id)init __attribute__((unavailable));
+ (instancetype)chatManagerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;

- (void)addClientWithSession:(ALMSession *)session URL:(NSURL *)url;

- (BOOL)connectAs:(ALMSession *)session;
- (BOOL)disconnectAs:(ALMSession *)session;
- (id)extValueForSession:(ALMSession *)session;

- (NSDictionary *)subscribeToChats:(NSArray *)chats as:(ALMSession *)session;
- (BOOL)subscribeToChat:(ALMChat *)chat as:(ALMSession *)session;

- (NSDictionary *)unsubscribeFromChats:(NSArray *)chats as:(ALMSession *)session;
- (BOOL)unsubscribeFromChat:(ALMChat *)chat as:(ALMSession *)session;

- (BOOL)sendMessage:(ALMChatMessage *)message to:(ALMChat *)chat as:(ALMSession *)session;

@end
