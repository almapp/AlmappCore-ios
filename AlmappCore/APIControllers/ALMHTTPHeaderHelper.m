//
//  ALMHTTPHeaderHelper.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMHTTPHeaderHelper.h"

NSString *const kIncommingHttpHeaderFieldApiKey = @"X-Api-Key";
NSString *const kIncommingHttpHeaderFieldAccessToken = @"Access-Token";
NSString *const kIncommingHttpHeaderFieldTokenType = @"Token-Type";
NSString *const kIncommingHttpHeaderFieldExpiry = @"Expiry";
NSString *const kIncommingHttpHeaderFieldClient = @"Client";
NSString *const kIncommingHttpHeaderFieldUID = @"Uid";

NSString *const kOutgoingHttpHeaderFieldApiKey = @"X-Api-Key";
NSString *const kOutgoingHttpHeaderFieldAccessToken = @"access_token-Token";
NSString *const kOutgoingHttpHeaderFieldTokenType = @"token_type";
NSString *const kOutgoingHttpHeaderFieldExpiry = @"expiry";
NSString *const kOutgoingHttpHeaderFieldClient = @"client";
NSString *const kOutgoingHttpHeaderFieldUID = @"uid";

@implementation ALMHTTPHeaderHelper

+ (void)setHeaders:(NSDictionary *)headers toCredential:(ALMCredential *)credential {
    credential.uid             = headers[kIncommingHttpHeaderFieldUID];
    credential.tokenAccessKey  = headers[kIncommingHttpHeaderFieldAccessToken];
    credential.tokenExpiration = [[headers objectForKey:kIncommingHttpHeaderFieldExpiry] integerValue];
    credential.client          = headers[kIncommingHttpHeaderFieldClient];
    credential.tokenType       = headers[kIncommingHttpHeaderFieldTokenType];
}

+ (NSDictionary *)createHeaderHashForApiKey:(NSString *)apiKey {
    return @{kOutgoingHttpHeaderFieldApiKey : apiKey};
}

+ (NSDictionary *)createHeaderHashForCredential:(ALMCredential *)credential apiKey:(NSString *)apiKey {
    if (credential) {
        return @{ kOutgoingHttpHeaderFieldAccessToken : credential.tokenAccessKey,
                  kOutgoingHttpHeaderFieldTokenType   : credential.tokenType,
                  kOutgoingHttpHeaderFieldClient      : credential.client,
                  kOutgoingHttpHeaderFieldUID         : credential.uid,
                  kOutgoingHttpHeaderFieldExpiry      : [NSString stringWithFormat:@"%ld", (long)credential.tokenExpiration],
                  kOutgoingHttpHeaderFieldApiKey      : apiKey};
    }
    else {
        return [self createHeaderHashForApiKey:apiKey];
    }
}

+ (void)setHttpRequestHeaders:(NSDictionary *)headers toSerializer:(AFHTTPRequestSerializer *)requestSerializer {
    for (NSString *headerField in headers.allKeys) {
        NSString *httpHeaderValue = headers[headerField];
        [requestSerializer setValue:httpHeaderValue forHTTPHeaderField:headerField];
    }
}

@end
