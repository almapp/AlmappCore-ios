//
//  ALMSessionManager.m
//  AlmappCore
//
//  Created by Patricio López on 20-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSessionManager.h"

NSString *const kDefaultLoginPath = @"auth/sign_in";

@interface ALMSessionManager ()

@property (strong, nonatomic) ALMSession *actualSession;

@end

@implementation ALMSessionManager

+ (instancetype)sessionManagerWithCoreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    return [[super alloc] initWithCoreModuleDelegate:coreDelegate];
}

- (void)setCurrentSession:(ALMSession *)newSession {
    if ([_sessionManagerDelegate respondsToSelector:@selector(sessionManager:shouldChangeToSession:)]) {
        if (![_sessionManagerDelegate sessionManager:self shouldChangeToSession:newSession]) {
            return;
        }
    }
    _actualSession = newSession;
     if ([_sessionManagerDelegate respondsToSelector:@selector(sessionManager:didChangeSessionTo:)]) {
         [_sessionManagerDelegate sessionManager:self didChangeSessionTo:newSession];
     }
}

- (ALMSession *)currentSession {
    return _actualSession;
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

- (NSString *)loginPostPath:(NSURL *)url {
    if ([_sessionManagerDelegate respondsToSelector:@selector(sessionManager:loginPostPathFor:)]) {
        return [_sessionManagerDelegate sessionManager:self loginPostPathFor:url];
    } else {
        return kDefaultLoginPath;
    }
}

- (NSDictionary *)loginParams:(ALMCredential *)credential {
    if ([_sessionManagerDelegate respondsToSelector:@selector(sessionManager:loginParamsFor:)]) {
        return [_sessionManagerDelegate sessionManager:self loginParamsFor:credential];
    } else {
        return @{ @"email" : credential.email,
                  @"password" : credential.password };
    }
}

@end
