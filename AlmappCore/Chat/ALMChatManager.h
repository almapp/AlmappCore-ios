//
//  ALMChatManager.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FayeCpp/FayeCppClient.h>

#import "ALMChatManagerDelegate.h"
#import "ALMSession.h"
#import "ALMChat.h"

@interface ALMChatManager : NSObject <FayeCppClientDelegate>

@property (weak, nonatomic) id<ALMChatManagerDelegate> chatManagerDelegate;
@property (assign, nonatomic) BOOL shouldLog;
@property (strong, nonatomic) NSURL *chatURL;
@property (strong, nonatomic) RLMRealm *chatRealm;

+ (instancetype)chatManagerWithURL:(NSURL *)url inRealm:(RLMRealm *)realm;

- (void)addClientWithSession:(ALMSession *)session URL:(NSURL *)url;

- (BOOL)connectAs:(ALMSession *)session;
- (BOOL)disconnectAs:(ALMSession *)session;

- (NSDictionary *)subscribeToChats:(NSArray *)chats as:(ALMSession *)session;
- (BOOL)subscribeToChat:(ALMChat *)chat as:(ALMSession *)session;

- (NSDictionary *)unsubscribeFromChats:(NSArray *)chats as:(ALMSession *)session;
- (BOOL)unsubscribeFromChat:(ALMChat *)chat as:(ALMSession *)session;

- (BOOL)sendMessage:(ALMChatMessage *)message to:(ALMChat *)chat as:(ALMSession *)session;

@end
