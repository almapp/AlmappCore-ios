//
//  ALMChatManager.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMChatManager.h"

@interface ALMChatManager ()

@property (strong, nonatomic) FayeCppClient *fayeClient;

- (NSString *)channelNameForChat:(ALMChat *)chat as:(ALMSession *)session;

@end

@implementation ALMChatManager 

#pragma mark - Constructor

+ (instancetype)chatManagerWithURL:(NSURL *)url {
    ALMChatManager *manager = [[self alloc] init];
    manager.fayeClient = [[FayeCppClient alloc] init];
    manager.fayeClient.delegate = manager;
    manager.fayeClient.urlString = url.absoluteString;
    return manager;
}


#pragma mark - Connection

- (BOOL)connectAs:(ALMSession *)session {
    // TODO: add auth headers
    BOOL success = [_fayeClient connect];
    return success;
}

- (BOOL)disconnectAs:(ALMSession *)session {
    [_fayeClient disconnect];
    BOOL success = [_fayeClient isFayeConnected];
    return success;
}


#pragma mark - Messaging

- (NSDictionary *)parseOutgoingMessage:(ALMChatMessage *)message in:(ALMChat *)chat as:(ALMSession *)session {
    message.user = session.user;
    message.chat = chat;
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:parseOutgoingMessage:in:as:)]) {
        return [self.chatManagerDelegate chatManager:self parseOutgoingMessage:message in:chat as:session];
    }
    else {
        NSDictionary *jsonDictionary = message.JSONDictionary;
        return jsonDictionary;
    }
}

- (ALMChatMessage *)parseIncommingMessage:(NSDictionary *)data from:(ALMChat *)chat {

    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:parseOutgoingMessage:in:as:)]) {
        return [self.chatManagerDelegate chatManager:self parseIncommingMessage:data from:chat];
    }
    else {
        return nil;
        // TODO: get message
    }
}

- (BOOL)sendMessage:(ALMChatMessage *)message to:(ALMChat *)chat as:(ALMSession *)session {
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:shouldSendMessage:to:as:)]) {
        if (![self.chatManagerDelegate chatManager:self shouldSendMessage:message to:chat as:session]){
            return NO;
        }
    }
    
    NSDictionary *jsonMessage = [self parseOutgoingMessage:message in:chat as:session];
    NSString *channel = [self channelNameForChat:chat as:session];
    
    BOOL success = [_fayeClient sendMessage:jsonMessage toChannel:channel];
    return success;
}


#pragma mark - Subscribing

- (ALMChat *)chatForChannel:(NSString *)channel {
    return nil;
    // TODO: get chat
}

- (NSString *)channelNameForChat:(ALMChat *)chat as:(ALMSession *)session {
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:channelNameForChat:as:)]) {
        NSString *channelName = [self.chatManagerDelegate chatManager:self channelNameForChat:chat as:session];
        if ([[channelName substringToIndex:1] isEqualToString:@"/"]) {
            return channelName;
        } else {
            return [NSString stringWithFormat:@"/%@", channelName];
        }
    }
    else {
        return [NSString stringWithFormat:@"/%lld", chat.resourceID];
    }
}

- (NSDictionary *)subscribedToChats:(NSArray *)chats as:(ALMSession *)session {
    NSMutableDictionary *successHash = [NSMutableDictionary dictionaryWithCapacity:chats.count];
    for (ALMChat *chat in chats) {
        BOOL success = [self subscribedToChat:chat as:session];
        [successHash setObject:@(success) forKey:chat];
    }
    return successHash;
}

- (BOOL)subscribedToChat:(ALMChat *)chat as:(ALMSession *)session {
    NSString *channelName = [self channelNameForChat:chat as:session];
    BOOL success = [_fayeClient subscribeToChannel:channelName];
    return success;
}

- (NSDictionary *)unsubscribedFromChats:(NSArray *)chats as:(ALMSession *)session {
    NSMutableDictionary *successHash = [NSMutableDictionary dictionaryWithCapacity:chats.count];
    for (ALMChat *chat in chats) {
        BOOL success = [self unsubscribedFromChat:chat as:session];
        [successHash setObject:@(success) forKey:chat];
    }
    return successHash;
}

- (BOOL)unsubscribedFromChat:(ALMChat *)chat as:(ALMSession *)session {
    NSString *channelName = [self channelNameForChat:chat as:session];
    BOOL success = [_fayeClient unsubscribeFromChannel:channelName];
    return success;
}


#pragma mark - FayeCppClientDelegate Implementation

- (void)onFayeClient:(FayeCppClient *)client error:(NSError *)error {
    if (self.shouldLog) {
        NSLog(@"Error: %@", error);
    }
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:error:)]) {
        [self.chatManagerDelegate chatManager:self error:error];
    }
}

- (void)onFayeClient:(FayeCppClient *)client receivedMessage:(NSDictionary *)message fromChannel:(NSString *)channel {
    if (self.shouldLog) {
        NSLog(@"On channel: %@", channel);
        NSLog(@"receivedMessage: %@", message);
    }
    
    ALMChat *chat = [self chatForChannel:channel];
    ALMChatMessage *parsedMessage = [self parseIncommingMessage:message from:chat];
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:didRecieveMessage:)]) {
        [self.chatManagerDelegate chatManager:self didRecieveMessage:parsedMessage];
    }
}

- (void)onFayeClient:(FayeCppClient *)client subscribedToChannel:(NSString *)channel {
    if (self.shouldLog) {
        NSLog(@"Susbcribed to: %@", channel);
    }
    
    ALMChat *chat = [self chatForChannel:channel];
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:subscribedTo:as:)]) {
        [self.chatManagerDelegate chatManager:self subscribedTo:chat as:nil];
        // TODO: session
    }
}

- (void)onFayeClient:(FayeCppClient *)client unsubscribedFromChannel:(NSString *)channel {
    if (self.shouldLog) {
        NSLog(@"Unsusbcribed to: %@", channel);
    }
    
    ALMChat *chat = [self chatForChannel:channel];
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:unsubscribedFrom:as:)]) {
        [self.chatManagerDelegate chatManager:self unsubscribedFrom:chat as:nil];
        // TODO: session
    }
}

- (void)onFayeClientConnected:(FayeCppClient *)client {
    if (self.shouldLog) {
        NSLog(@"FayeClientConnected");
    }
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:connectedAs:)]) {
        [self.chatManagerDelegate chatManager:self connectedAs:nil];
        // TODO: session
    }
}

- (void)onFayeClientDisconnected:(FayeCppClient *)client {
    if (self.shouldLog) {
        NSLog(@"FayeClientDisconnected");
    }
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:disconnectedAs:)]) {
        [self.chatManagerDelegate chatManager:self disconnectedAs:nil];
        // TODO: session
    }
}

- (void)onFayeTransportConnected:(FayeCppClient *)client {
    if (self.shouldLog) {
        NSLog(@"TransportConnected");
    }
}

- (void)onFayeTransportDisconnected:(FayeCppClient *)client {
    if (self.shouldLog) {
        NSLog(@"TransportDisconnected");
    }
}

@end
