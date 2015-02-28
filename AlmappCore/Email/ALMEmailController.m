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

- (ALMEmailFolder *)folder:(NSString *)identifier {
    RLMRealm *realm = self.realm;
    ALMEmailFolder *folder = [ALMEmailFolder objectsInRealm:realm where:[NSString stringWithFormat:@"%@ = '%@'", kRIdentifier, identifier]].firstObject;
    if (!folder) {
        [realm beginWriteTransaction];
        folder = [[ALMEmailFolder alloc] init];
        folder.identifier = identifier;
        folder = [ALMEmailFolder createInRealm:realm withObject:folder];
        [realm commitWriteTransaction];
    }
    return folder;
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

- (void)saveLastMails:(NSInteger)count on:(ALMEmailFolder *)folder {
    if (folder.threads.count <= count) {
        return;
    }
    
    RLMRealm *realm = self.realm;
    [realm beginWriteTransaction];
    
    RLMResults *orderedThreads = [folder threadsSortedAscending:NO];
    
    for (NSUInteger i = 0; i < orderedThreads.count; i++) {
        if (i >= count) {
            [folder deleteThread:orderedThreads[i] force:NO];
        }
    }
    [realm commitWriteTransaction];
}

- (BOOL)isAccessTokenValid {
    return self.emailToken && !self.emailToken.isExpired;
}

@end
