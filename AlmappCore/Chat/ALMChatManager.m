//
//  ALMChatManager.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMChatManager.h"
#import "ALMCore.h"
#import "ALMController.h"
#import "ALMConstants.h"



@interface ALMChatManager ()

@property (weak, nonatomic) NSURL *chatURL;
@property (strong, nonatomic) NSMutableDictionary *clients;
@property (strong, nonatomic) NSMutableDictionary *chats;

- (NSString *)channelNameForChat:(ALMChat *)chat with:(ALMCredential *)credential;

@end



@implementation ALMChatManager 

#pragma mark - Constructor

+ (instancetype)chatManagerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    ALMChatManager *manager = [[super alloc] initWithCoreModuleDelegate:coreDelegate];
    manager.chatURL = url;
    manager.shouldLog = YES;
    manager.clients = [NSMutableDictionary dictionary];
    manager.chats = [NSMutableDictionary dictionary];
    
    return manager;
}


#pragma mark - Clients

- (void)addClientWithCredential:(ALMCredential *)credential {
    return [self addClientWithCredential:credential URL:nil];
}

- (void)addClientWithCredential:(ALMCredential *)credential URL:(NSURL *)url {
    FayeCppClient *client = [self clientForCredential:credential];
    if (!client) {
        client = [[FayeCppClient alloc] init];
        client.delegate = self;
        [_clients setObject:client forKey:credential.email];
    }
    NSString *absUrl = @"http://almapp.me:80/faye";//(url) ? url.absoluteString : self.chatURL.absoluteString;
    [client setUrlString:absUrl];
}

- (void)removeClient:(FayeCppClient *)client {
    NSString *sessionEmail = [_clients allKeysForObject:client][0];
    [_clients removeObjectForKey:sessionEmail];
}

- (FayeCppClient *)clientForCredential:(ALMCredential *)credential {
    FayeCppClient *client = [_clients objectForKey:credential.email];
    return client;
}

- (ALMCredential *)credentialForClient:(FayeCppClient *)client {
    NSString *credentialEmail = [_clients allKeysForObject:client][0];
    return (credentialEmail) ? [ALMCredential credentialForEmail:credentialEmail] : nil;
}

- (PMKPromise *)doAuthedWith:(ALMCredential *)credential {
    PMKPromise *promise = [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        /*
        [[ALMCore controller] authPromiseWithCredential:credential].then(^(NSString *token) {
            FayeCppClient *client = [self clientForCredential:credential];
            
            //[client setExtValue:@{@"token" : token}]; // TODO EXT
            
            fulfiller(client);
            
        }).catch(^(NSError *error) {
            rejecter(error);
        });
         */
    }];
    return promise;
}

#pragma mark - Connection

- (PMKPromise *)connectWith:(ALMCredential *)credential {
    return [self doAuthedWith:credential].then(^(FayeCppClient *client) {
        BOOL success = [client connect];
        return success;
    });
}

- (PMKPromise *)disconnectWith:(ALMCredential *)credential {
    return [self doAuthedWith:credential].then(^(FayeCppClient *client) {
        [client disconnect];
        BOOL success = [client isFayeConnected];
        return success;
    });
}


#pragma mark - Messaging

- (NSDictionary *)parseOutgoingMessage:(ALMChatMessage *)message in:(ALMChat *)chat with:(ALMCredential *)credential {
    message.chat = chat;
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:parseOutgoingMessage:in:with:)]) {
        return [self.chatManagerDelegate chatManager:self parseOutgoingMessage:message in:chat with:credential];
    }
    else {
        NSDictionary *jsonDictionary = message.JSONDictionary;
        return jsonDictionary;
    }
}

- (ALMChatMessage *)parseIncommingMessage:(NSDictionary *)data from:(ALMChat *)chat {

    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:parseIncommingMessage:from:)]) {
        return [self.chatManagerDelegate chatManager:self parseIncommingMessage:data from:chat];
    }
    else {
        return nil;
        // TODO: get message
        // [ALMChatMessage createOrUpdateInRealm:nil withJSONDictionary:data];
    }
}

- (PMKPromise *)sendMessage:(ALMChatMessage *)message to:(ALMChat *)chat with:(ALMCredential *)credential {
    if (self.chatListenerDelegate && [self.chatListenerDelegate respondsToSelector:@selector(chatManager:shouldSendMessage:to:with:)]) {
        if (![self.chatListenerDelegate chatManager:self shouldSendMessage:message to:chat with:credential]) {
            return nil;
        }
    }
    
    return [self doAuthedWith:credential].then(^(FayeCppClient *client) {
        //NSDictionary *jsonMessage = [self parseOutgoingMessage:message in:chat with:credential];
        //NSString *channel = [self channelNameForChat:chat with:credential];

        BOOL success = [client sendMessage:@{@"data":@"data"} toChannel:@"/chat/A3"];
        return success;
    });
}


#pragma mark - Subscribing

- (ALMChat *)chatForChannel:(NSString *)channel {
    return _chats[channel];
}

- (NSString *)channelNameForChat:(ALMChat *)chat with:(ALMCredential *)credential {
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:channelNameForChat:with:)]) {
        NSString *channelName = [self.chatManagerDelegate chatManager:self channelNameForChat:chat with:credential];
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

- (PMKPromise *)subscribeToChats:(NSArray *)chats with:(ALMCredential *)credential {
    NSMutableArray *successHash = [NSMutableArray arrayWithCapacity:chats.count];
    for (ALMChat *chat in chats) {
        PMKPromise* promise = [self subscribeToChat:chat with:credential];
        [successHash addObject:promise];
    }
    return [PMKPromise when:successHash];
}

- (PMKPromise *)subscribeToChat:(ALMChat *)chat with:(ALMCredential *)credential {
    return [self doAuthedWith:credential].then(^(FayeCppClient *client) {
        NSString *channelName = [self channelNameForChat:chat with:credential];
        BOOL success = [client subscribeToChannel:channelName];
        if (success) {
            [_chats setObject:chat forKey:channelName];
            return YES;
        }
        return success;
    });
}

- (PMKPromise *)unsubscribeFromChats:(NSArray *)chats with:(ALMCredential *)credential {
    NSMutableArray *successHash = [NSMutableArray arrayWithCapacity:chats.count];
    for (ALMChat *chat in chats) {
        PMKPromise* promise = [self unsubscribeFromChat:chat with:credential];
        [successHash addObject:promise];
    }
    return [PMKPromise when:successHash];
}

- (PMKPromise *)unsubscribeFromChat:(ALMChat *)chat with:(ALMCredential *)credential {
    return [self doAuthedWith:credential].then(^(FayeCppClient *client) {
        NSString *channelName = [self channelNameForChat:chat with:credential];
        BOOL success = [client unsubscribeFromChannel:channelName];
        if (success) {
            [_chats setObject:chat forKey:channelName];
            return YES;
        }
        return success;
    });
}


#pragma mark - FayeCppClientDelegate Implementation

- (void)onFayeClient:(FayeCppClient *)client error:(NSError *)error {
    if (self.shouldLog) {
        NSLog(@"Error: %@", error);
    }
    
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(chatManager:error:)]) {
        [self.chatManagerDelegate chatManager:self error:error];
    }
    
    if (self.chatListenerDelegate && [self.chatListenerDelegate respondsToSelector:@selector(chatManager:error:)]) {
        [self.chatListenerDelegate chatManager:self error:error];
    }
}

- (void)onFayeClient:(FayeCppClient *)client receivedMessage:(NSDictionary *)message fromChannel:(NSString *)channel {
    if (self.shouldLog) {
        NSLog(@"On channel: %@", channel);
        NSLog(@"receivedMessage: %@", message);
    }
    
    ALMChat *chat = [self chatForChannel:channel];
    ALMChatMessage *parsedMessage = [self parseIncommingMessage:message from:chat];
    
    if (self.chatListenerDelegate && [self.chatListenerDelegate respondsToSelector:@selector(chatManager:didRecieveMessage:)]) {
        [self.chatListenerDelegate chatManager:self didRecieveMessage:parsedMessage];
    }
}

- (void)onFayeClient:(FayeCppClient *)client subscribedToChannel:(NSString *)channel {
    if (self.shouldLog) {
        NSLog(@"Susbcribed to: %@", channel);
    }
    
    ALMChat *chat = [self chatForChannel:channel];
    ALMCredential *credential = [self credentialForClient:client];
    
    if (self.chatListenerDelegate && [self.chatListenerDelegate respondsToSelector:@selector(chatManager:subscribedTo:with:)]) {
        [self.chatListenerDelegate chatManager:self subscribedTo:chat with:credential];
    }
}

- (void)onFayeClient:(FayeCppClient *)client unsubscribedFromChannel:(NSString *)channel {
    if (self.shouldLog) {
        NSLog(@"Unsusbcribed to: %@", channel);
    }
    
    ALMChat *chat = [self chatForChannel:channel];
    ALMCredential *credential = [self credentialForClient:client];

    [_chats removeObjectForKey:channel];
    
    if (self.chatListenerDelegate && [self.chatListenerDelegate respondsToSelector:@selector(chatManager:unsubscribedFrom:with:)]) {
        [self.chatListenerDelegate chatManager:self unsubscribedFrom:chat with:credential];
    }
}

- (void)onFayeClientConnected:(FayeCppClient *)client {
    if (self.shouldLog) {
        NSLog(@"FayeClientConnected");
    }
    
    ALMCredential *credential = [self credentialForClient:client];
    
    if (self.chatListenerDelegate && [self.chatListenerDelegate respondsToSelector:@selector(chatManager:connectedWith:)]) {
        [self.chatListenerDelegate chatManager:self connectedWith:credential];
    }
}

- (void)onFayeClientDisconnected:(FayeCppClient *)client {
    if (self.shouldLog) {
        NSLog(@"FayeClientDisconnected");
    }
    
    ALMCredential *credential = [self credentialForClient:client];
    [self removeClient:client];
    
    if (self.chatListenerDelegate && [self.chatListenerDelegate respondsToSelector:@selector(chatManager:disconnectedWith:)]) {
        [self.chatListenerDelegate chatManager:self disconnectedWith:credential];
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
