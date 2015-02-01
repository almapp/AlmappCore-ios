//
//  ALMChatManagerBlock.h
//  AlmappCore
//
//  Created by Patricio López on 31-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMChatManager.h"

@interface ALMChatManagerBlock : NSObject <ALMChatListenerDelegate>

@property (nonatomic, copy) void (^onError)(NSError *error);

@property (nonatomic, copy) void (^onConnectedWith)(ALMCredential *credential);
@property (nonatomic, copy) void (^onDisconnectedWith)(ALMCredential *credential);

@property (nonatomic, copy) void (^onSubscribedTo)(ALMChat *chat, ALMCredential *credential);
@property (nonatomic, copy) void (^onUnsubscribedTo)(ALMChat *chat, ALMCredential *credential);

@property (nonatomic, copy) BOOL (^shouldSendMessage)(ALMChatMessage *message, ALMChat *chat);

@property (nonatomic, copy) void (^onMessageRecieve)(ALMChatMessage *message);
@property (nonatomic, copy) void (^onMessageSent)(ALMChatMessage *message);

@end
