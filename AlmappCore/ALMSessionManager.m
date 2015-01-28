//
//  ALMSessionManager.m
//  AlmappCore
//
//  Created by Patricio López on 20-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSessionManager.h"

NSString *const kDefaultLoginPath = @"auth/sign_in";

@implementation ALMSessionManager

- (instancetype)initWithDelegate:(id<ALMSessionManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.sessionManagerDelegate = delegate;
    }
    return self;
}

- (RLMResults *)availableSessions {
    return [self availableSessionsInRealm:[RLMRealm defaultRealm]];
}

- (RLMResults *)availableSessionsInRealm:(RLMRealm *)realm {
    return [ALMSession allObjectsInRealm:realm];
}

- (NSString *)loginPostPath:(ALMSession *)session {
    if ([_sessionManagerDelegate respondsToSelector:@selector(loginPostPath:)]) {
        return [_sessionManagerDelegate loginPostPath:session];
    } else {
        return kDefaultLoginPath;
    }
}

- (NSDictionary *)loginParams:(ALMSession *)session {
    if ([_sessionManagerDelegate respondsToSelector:@selector(loginParams:)]) {
        return [_sessionManagerDelegate loginParams:session];
    } else {
        return @{ @"email" : session.email,
                  @"password" : session.password };
    }
}

@end
