//
//  ALMEmailController.m
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailController.h"
#import "ALMController.h"
#import "NSDate+JSON.h"
#import "ALMEmailConstants.h"
#import "ALMResourceConstants.h"

@implementation ALMEmailController

- (NSArray *)threadsLabeled:(ALMEmailLabel)labels ascending:(BOOL)ascending;{
    return [self threadsLabeled:labels inRealm:self.session.realm ascending:ascending];
}

- (NSArray *)threadsLabeled:(ALMEmailLabel)labels inRealm:(RLMRealm *)realm ascending:(BOOL)ascending;{
    NSMutableArray *threads = [NSMutableArray array];
    id iterable = [ALMEmailThread threadsSortedAscending:ascending realm:realm];
    for (ALMEmailThread *thread in iterable) {
        for (ALMEmail *email in thread.emails) {
            if (email.labels & labels) {
                [threads addObject:thread];
                break;
            }
        }
    }
    return threads;
}

- (void)saveLastThreads:(NSInteger)count labeled:(ALMEmailLabel)labels {
    [self saveLastThreads:count labeled:labels inRealm:self.realm];
}

- (void)saveLastThreads:(NSInteger)count labeled:(ALMEmailLabel)labels inRealm:(RLMRealm *)realm {
    [realm beginWriteTransaction];
    
    RLMResults *orderedThreads = [ALMEmailThread threadsSortedAscending:NO realm:realm];
    
    for (NSInteger i = orderedThreads.count - 1; i >= 0 && [ALMEmailThread allObjectsInRealm:realm].count > count; i--) {
        ALMEmailThread *thread = orderedThreads[i];
        [thread deleteEmailsForced:YES];
        [realm deleteObject:thread];
    }
    
    [realm commitWriteTransaction];
}

- (ALMEmailToken *)emailToken {
    return self.session.emailToken;
}

- (PMKPromise *)saveAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken code:(NSString *)code expirationDate:(NSDate *)expirationDate provider:(NSString *)provider {
    
    NSDictionary *token = @{@"email_token": @{@"provider" : provider,
                                              @"access_token" : accessToken,
                                              @"refresh_token" : refreshToken,
                                              @"code" : code,
                                              @"expires_at" : expirationDate.JSON}};
    
    return [self.controller POST:@"me/email_client/token" parameters:token].then( ^(id response, NSURLSessionDataTask *task) {
        return [self saveAccessTokenFromResponse:response];
    });
}

- (PMKPromise *)getValidAccessToken {
    if (self.isAccessTokenValid) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
            fulfiller(self.emailToken);
        }];
    }
    else {
        return [self getForceAccessToken];
    }
}

- (PMKPromise *)getForceAccessToken {
    return [self.controller GET:@"me/email_client/token" parameters:nil].then( ^(id response, NSURLSessionDataTask *task) {
        return [self saveAccessTokenFromResponse:response];
    });
}

- (ALMEmailToken *)saveAccessTokenFromResponse:(id)response {
    RLMRealm *realm = self.session.realm;
    [realm beginWriteTransaction];
    
    ALMEmailToken *token = [[ALMEmailToken alloc] initWithJSONDictionary:response];
    token.email = self.session.email;
    
    token = [ALMEmailToken createOrUpdateInRealm:realm withObject:token];
    self.session.emailToken = token;
    
    [realm commitWriteTransaction];
    return token;
}
/*
- (void)saveLastMails:(NSInteger)count on:(ALMEmailFolder *)folder {
    if (folder.threads.count <= count) {
        return;
    }
    
    RLMRealm *realm = self.realm;
    [realm beginWriteTransaction];
    
    RLMResults *orderedThreads = [folder threadsSortedAscending:NO];
    
    for (NSInteger i = folder.threads.count - 1; i >= 0 && folder.threads.count > count; i--) {
        [folder deleteThread:orderedThreads[i] force:NO];
    }
    
    [realm commitWriteTransaction];
}
 */

- (BOOL)isAccessTokenValid {
    return self.emailToken && !self.emailToken.isExpired;
}

@end
