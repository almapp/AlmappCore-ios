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

- (BOOL)sendMessage:(ALMChatMessage *)message to:(ALMChat *)chat as:(ALMSession *)session {
    message.user = session.user;
    message.chat = chat;
    
    NSString *channel = [self channelNameForChat:chat as:session];
    NSDictionary *jsonDictionary = message.JSONDictionary;
    
    BOOL success = [_fayeClient sendMessage:jsonDictionary toChannel:channel];
    return success;
}


#pragma mark - Subscribing

- (NSString *)channelNameForChat:(ALMChat *)chat as:(ALMSession *)session {
    if (self.chatManagerDelegate && [self.chatManagerDelegate respondsToSelector:@selector(channelNameForChat:as:)]) {
        NSString *channelName = [self.chatManagerDelegate channelNameForChat:chat as:session];
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



- (void)onFayeClient:(FayeCppClient *)client error:(NSError *)error {
    
}

- (void)onFayeClient:(FayeCppClient *)client receivedMessage:(NSDictionary *)message fromChannel:(NSString *)channel {
    
}

- (void)onFayeClient:(FayeCppClient *)client subscribedToChannel:(NSString *)channel {
    
}

- (void)onFayeClient:(FayeCppClient *)client unsubscribedFromChannel:(NSString *)channel {
    
}

- (void)onFayeClientConnected:(FayeCppClient *)client {
    
}

- (void)onFayeClientDisconnected:(FayeCppClient *)client {
    
}

- (void)onFayeTransportConnected:(FayeCppClient *)client {
    
}

- (void)onFayeTransportDisconnected:(FayeCppClient *)client {
    
}

@end
