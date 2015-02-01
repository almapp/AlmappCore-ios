//
//  ALMChatListenerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 30-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMChatManager, ALMCredential, ALMChat, ALMChatMessage;

@protocol ALMChatListenerDelegate <NSObject>

@optional

- (void)chatManager:(ALMChatManager *)manager error:(NSError *)error;

- (void)chatManager:(ALMChatManager *)manager connectedWith:(ALMCredential *)credential;
- (void)chatManager:(ALMChatManager *)manager disconnectedWith:(ALMCredential *)credential;

- (void)chatManager:(ALMChatManager *)manager subscribedTo:(ALMChat *)chat with:(ALMCredential *)credential;
- (void)chatManager:(ALMChatManager *)manager unsubscribedFrom:(ALMChat *)chat with:(ALMCredential *)credential;

- (BOOL)chatManager:(ALMChatManager *)manager shouldSendMessage:(ALMChatMessage *)message to:(ALMChat *)chat with:(ALMCredential *)credential;
- (void)chatManager:(ALMChatManager *)manager didSendMessage:(ALMChatMessage *)message;
- (void)chatManager:(ALMChatManager *)manager didRecieveMessage:(ALMChatMessage *)message;

@end