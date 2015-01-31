//
//  ALMSessionManager.m
//  AlmappCore
//
//  Created by Patricio López on 20-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSessionManager.h"

@interface ALMSessionManager ()

@property (strong, nonatomic) ALMSession *actualSession;

@end

@implementation ALMSessionManager

+ (instancetype)sessionManagerWithCoreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    return [[super alloc] initWithCoreModuleDelegate:coreDelegate];
}

- (void)setCurrentSession:(ALMSession *)newSession {
    if (_sessionManagerDelegate && [_sessionManagerDelegate respondsToSelector:@selector(sessionManager:shouldChangeToSession:)]) {
        if (![_sessionManagerDelegate sessionManager:self shouldChangeToSession:newSession]) {
            return;
        }
    }
    _actualSession = newSession;
     if (_sessionManagerDelegate && [_sessionManagerDelegate respondsToSelector:@selector(sessionManager:didChangeSessionTo:)]) {
         [_sessionManagerDelegate sessionManager:self didChangeSessionTo:newSession];
     }
}

- (ALMSession *)currentSession {
    if (_sessionManagerDelegate && [_sessionManagerDelegate respondsToSelector:@selector(sessionManagerGetCurrentSession)]) {
        return [_sessionManagerDelegate sessionManagerGetCurrentSession];
    } else {
        return _actualSession;
    }
}

- (RLMResults *)availableSessions {
    return [self availableSessionsInRealm:[RLMRealm defaultRealm]];
}

- (ALMSessionManager *)sessionManager  {
    return self;
}

- (RLMResults *)availableSessionsInRealm:(RLMRealm *)realm {
    return [ALMSession allObjectsInRealm:realm];
}


@end
