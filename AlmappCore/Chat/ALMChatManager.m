//
//  ALMChatManager.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMChatManager.h"
#import "ALMRequestManager.h"
#import "ALMHTTPHeaderHelper.h"

@interface ALMChatManager ()

@property (weak, nonatomic) NSURL *chatURL;
@property (strong, nonatomic) NSMutableDictionary *clients;
@property (strong, nonatomic) NSMutableDictionary *chats;

- (NSString *)channelNameForChat:(ALMChat *)chat as:(ALMSession *)session;

@end

@implementation ALMChatManager 

#pragma mark - Constructor

+ (instancetype)chatManagerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    ALMChatManager *manager = [[super alloc] initWithCoreModuleDelegate:coreDelegate];
    manager.chatURL = url;
    return manager;
}


#pragma mark - Clients

- (void)addClientWithSession:(ALMSession *)session URL:(NSURL *)url {
    FayeCppClient *client = [_clients objectForKey:session.email];
    if (!client) {
        client = [[FayeCppClient alloc] init];
        client.delegate = self;
        [_clients setObject:client forKey:session.email];
    }
    client.urlString = url.absoluteString;
}

- (ALMSession *)removeClient:(FayeCppClient *)client {
    NSString *sessionEmail = [_clients allKeysForObject:client][0];
    if (sessionEmail) {
        ALMSession *session = [ALMSession sessionWithEmail:sessionEmail inRealm:[self defaultRealm]];
        [_clients removeObjectForKey:sessionEmail];
        return session;
    }
    return nil;
}

- (FayeCppClient *)clientForSession:(ALMSession *)session {
    FayeCppClient *client = [_clients objectForKey:session];
    if (!client) {
        [self addClientWithSession:session URL:self.chatURL];
        client = [self clientForSession:session];
    }
    return client;
}

- (ALMSession *)sessionForClient:(FayeCppClient *)client {
    NSString *sessionEmail = [_clients allKeysForObject:client][0];
    return (sessionEmail) ? [ALMSession sessionWithEmail:sessionEmail inRealm:[self defaultRealm]] : nil;
}


#pragma mark - Connection

- (BOOL)connectAs:(ALMSession *)session {
    FayeCppClient *client = [self clientForSession:session];
    
    [client setExtValue:[self extValueForSession:session]];
    
    BOOL success = [client connect];
    return success;
}

- (BOOL)disconnectAs:(ALMSession *)session {
    FayeCppClient *client = [self clientForSession:session];
    [client disconnect];
    BOOL success = [client isFayeConnected];
    return success;
}

- (id)extValueForSession:(ALMSession *)session {
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:extValueFor:)]) {
        id ext = [self.chatManagerDelegate chatManager:self extValueFor:session];
        return ext;
    }
    else {
        NSDictionary *headers = [ALMHTTPHeaderHelper createHeaderHashForSession:session apiKey:[self apiKey]];
        return headers;
    }
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
        // [ALMChatMessage createOrUpdateInRealm:nil withJSONDictionary:data];
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
    
    BOOL success = [[self clientForSession:session] sendMessage:jsonMessage toChannel:channel];
    return success;
}


#pragma mark - Subscribing

- (ALMChat *)chatForChannel:(NSString *)channel {
    return _chats[channel];
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

- (NSDictionary *)subscribeToChats:(NSArray *)chats as:(ALMSession *)session {
    NSMutableDictionary *successHash = [NSMutableDictionary dictionaryWithCapacity:chats.count];
    for (ALMChat *chat in chats) {
        BOOL success = [self subscribeToChat:chat as:session];
        [successHash setObject:@(success) forKey:chat];
    }
    return successHash;
}

- (BOOL)subscribeToChat:(ALMChat *)chat as:(ALMSession *)session {
    NSString *channelName = [self channelNameForChat:chat as:session];
    BOOL success = [[self clientForSession:session] subscribeToChannel:channelName];
    if (success) {
        [_chats setObject:chat forKey:channelName];
    }
    return success;
}

- (NSDictionary *)unsubscribeFromChats:(NSArray *)chats as:(ALMSession *)session {
    NSMutableDictionary *successHash = [NSMutableDictionary dictionaryWithCapacity:chats.count];
    for (ALMChat *chat in chats) {
        BOOL success = [self unsubscribeFromChat:chat as:session];
        [successHash setObject:@(success) forKey:chat];
    }
    return successHash;
}

- (BOOL)unsubscribeFromChat:(ALMChat *)chat as:(ALMSession *)session {
    NSString *channelName = [self channelNameForChat:chat as:session];
    BOOL success = [[self clientForSession:session] unsubscribeFromChannel:channelName];
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
    ALMSession *session = [self sessionForClient:client];
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:subscribedTo:as:)]) {
        [self.chatManagerDelegate chatManager:self subscribedTo:chat as:session];
    }
}

- (void)onFayeClient:(FayeCppClient *)client unsubscribedFromChannel:(NSString *)channel {
    if (self.shouldLog) {
        NSLog(@"Unsusbcribed to: %@", channel);
    }
    
    ALMChat *chat = [self chatForChannel:channel];
    ALMSession *session = [self sessionForClient:client];

    [_chats removeObjectForKey:channel];
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:unsubscribedFrom:as:)]) {
        [self.chatManagerDelegate chatManager:self unsubscribedFrom:chat as:session];
    }
}

- (void)onFayeClientConnected:(FayeCppClient *)client {
    if (self.shouldLog) {
        NSLog(@"FayeClientConnected");
    }
    
    ALMSession *session = [self sessionForClient:client];
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:connectedAs:)]) {
        [self.chatManagerDelegate chatManager:self connectedAs:session];
    }
}

- (void)onFayeClientDisconnected:(FayeCppClient *)client {
    if (self.shouldLog) {
        NSLog(@"FayeClientDisconnected");
    }
    
    ALMSession *session = [self removeClient:client];
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:disconnectedAs:)]) {
        [self.chatManagerDelegate chatManager:self disconnectedAs:session];
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
