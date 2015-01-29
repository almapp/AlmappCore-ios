//
//  ALMHTTPHeaderHelper.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMSession.h"

extern NSString *const kIncommingHttpHeaderFieldApiKey;
extern NSString *const kIncommingHttpHeaderFieldAccessToken;
extern NSString *const kIncommingHttpHeaderFieldTokenType;
extern NSString *const kIncommingHttpHeaderFieldExpiry;
extern NSString *const kIncommingHttpHeaderFieldClient;
extern NSString *const kIncommingHttpHeaderFieldUID;

extern NSString *const kOutgoingHttpHeaderFieldApiKey;
extern NSString *const kOutgoingHttpHeaderFieldAccessToken;
extern NSString *const kOutgoingHttpHeaderFieldTokenType;
extern NSString *const kOutgoingHttpHeaderFieldExpiry;
extern NSString *const kOutgoingHttpHeaderFieldClient;
extern NSString *const kOutgoingHttpHeaderFieldUID;

@interface ALMHTTPHeaderHelper : NSObject

+ (void)setHeaders:(NSDictionary *)headers to:(ALMSession *)session;
+ (NSDictionary *)createHeaderHashForApiKey:(NSString *)apiKey;
+ (NSDictionary *)createHeaderHashForSession:(ALMSession *)session apiKey:(NSString *)apiKey;

@end
