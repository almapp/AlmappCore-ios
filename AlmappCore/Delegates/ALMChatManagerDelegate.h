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

- (NSString *)chatManager:(ALMChatManager *)manager channelNameForChat:(ALMChat *)chat as:(ALMSession *)session;

- (NSDictionary *)chatManager:(ALMChatManager *)manager parseOutgoingMessage:(ALMChatMessage *)message in:(ALMChat *)chat as:(ALMSession *)session;
- (ALMChatMessage *)chatManager:(ALMChatManager *)manager parseIncommingMessage:(NSDictionary *)message from:(ALMChat *)chat;
- (id)chatManager:(ALMChatManager *)manager extValueFor:(ALMSession *)session;

@end