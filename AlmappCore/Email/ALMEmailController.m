//
//  ALMEmailController.m
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailController.h"
#import "ALMController.h"

@implementation ALMEmailController

- (ALMEmailLabel *)label:(NSString *)identifier {
    RLMRealm *realm = self.realm;
    ALMEmailLabel *label = [ALMEmailLabel objectsInRealm:realm where:[NSString stringWithFormat:@"identifier = '%@'", identifier]].firstObject;
    if (!label) {
        [realm beginWriteTransaction];
        label = [[ALMEmailLabel alloc] init];
        label.identifier = identifier;
        label = [ALMEmailLabel createInRealm:realm withObject:label];
        [realm commitWriteTransaction];
    }
    return label;
}

- (ALMEmailToken *)emailToken {
    return self.session.emailToken;
}

- (PMKPromise *)saveAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken code:(NSString *)code expirationDate:(NSDate *)expirationDate provider:(NSString *)provider {
    
    NSDictionary *token = @{@"email_token": @{@"provider" : provider,
                                              @"access_token" : accessToken,
                                              @"refresh_token" : refreshToken,
                                              @"code" : code,
                                              @"expires_in" : expirationDate}};
    
    return [self.controller POST:@"me/email_client/email_tokens" parameters:token].then( ^(id response, NSURLSessionDataTask *task) {
        return [self saveAccessTokenFromResponse:response];
    });
}

- (PMKPromise *)getValidAccessToken {
    if (self.emailToken && !self.emailToken.isExpired) {
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
    
    //NSString *root = @"email_token";
    
    //ALMEmailToken *token = [[ALMEmailToken alloc] init];
    
    //token.provider = response[root][@""];
    //token.accessToken = response[root][@""];
    //token.expiresIn =
    // ALMEmailToken *token = [ALMEmailToken createOrUpdateInRealm:realm withJSONDictionary:response];
    ALMEmailToken *token = [[ALMEmailToken alloc] initWithJSONDictionary:response];
    token.email = self.session.email;
    
    token = [ALMEmailToken createOrUpdateInRealm:realm withObject:token];
    
    //[self.session.emailToken removeFromRealm];
    //self.session.emailToken = token;
    
    [realm commitWriteTransaction];
    return token;
}

@end
