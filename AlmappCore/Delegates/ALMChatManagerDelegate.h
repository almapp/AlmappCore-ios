//
//  ALMChatManagerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMChatManager, ALMSession, ALMChat, ALMChatMessage;

@protocol ALMChatManagerDelegate <NSObject>

- (void)chatManager:(ALMChatManager *)manager error:(NSError *)error;

- (void)chatManager:(ALMChatManager *)manager connectedAs:(ALMSession *)session;
- (void)chatManager:(ALMChatManager *)manager disconnectedAs:(ALMSession *)session;

- (void)chatManager:(ALMChatManager *)manager subscribedTo:(ALMChat *)chat as:(ALMSession *)session;
- (void)chatManager:(ALMChatManager *)manager unsubscribedFrom:(ALMChat *)chat as:(ALMSession *)session;

- (BOOL)chatManager:(ALMChatManager *)manager shouldSendMessage:(ALMChatMessage *)message to:(ALMChat *)chat as:(ALMSession *)session;
- (void)chatManager:(ALMChatManager *)manager didSendMessage:(ALMChatMessage *)message;
- (void)chatManager:(ALMChatManager *)manager didRecieveMessage:(ALMChatMessage *)message;

- (NSString *)chatManager:(ALMChatManager *)manager channelNameForChat:(ALMChat *)chat as:(ALMSession *)session;

- (NSDictionary *)chatManager:(ALMChatManager *)manager parseOutgoingMessage:(ALMChatMessage *)message in:(ALMChat *)chat as:(ALMSession *)session;
- (ALMChatMessage *)chatManager:(ALMChatManager *)manager parseIncommingMessage:(NSDictionary *)message from:(ALMChat *)chat;
- (id)chatManager:(ALMChatManager *)manager extValueFor:(ALMSession *)session;

@end