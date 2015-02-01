//
//  ALMChatManagerBlock.m
//  AlmappCore
//
//  Created by Patricio López on 31-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMChatManagerBlock.h"

@implementation ALMChatManagerBlock


- (void)chatManager:(ALMChatManager *)manager error:(NSError *)error {
    if (_onError) {
        _onError(error);
    }
}

- (void)chatManager:(ALMChatManager *)manager connectedWith:(ALMCredential *)credential {
    if (_onConnectedWith) {
        _onConnectedWith(credential);
    }
}

- (void)chatManager:(ALMChatManager *)manager disconnectedWith:(ALMCredential *)credential {
    if (_onDisconnectedWith) {
        _onDisconnectedWith(credential);
    }
}

- (void)chatManager:(ALMChatManager *)manager subscribedTo:(ALMChat *)chat with:(ALMCredential *)credential {
    if (_onSubscribedTo) {
        _onSubscribedTo(chat, credential);
    }
}

- (void)chatManager:(ALMChatManager *)manager unsubscribedFrom:(ALMChat *)chat with:(ALMCredential *)credential {
    if (_onUnsubscribedTo) {
        _onUnsubscribedTo(chat, credential);
    }
}

- (BOOL)chatManager:(ALMChatManager *)manager shouldSendMessage:(ALMChatMessage *)message to:(ALMChat *)chat with:(ALMCredential *)credential {
    if (_shouldSendMessage) {
        return _shouldSendMessage(message, chat);
    }
    else {
        return YES;
    }
}

- (void)chatManager:(ALMChatManager *)manager didSendMessage:(ALMChatMessage *)message {
    if (_onMessageSent) {
        _onMessageSent(message);
    }
}

- (void)chatManager:(ALMChatManager *)manager didRecieveMessage:(ALMChatMessage *)message {
    if (_onMessageRecieve) {
        _onMessageRecieve(message);
    }
}

@end
