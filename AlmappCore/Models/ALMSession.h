//
//  ALMSession.h
//  AlmappCore
//
//  Created by Patricio López on 20-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMUser.h"

@interface ALMSession : RLMObject

@property NSString *email;
@property NSString *password;

@property ALMUser *user;
@property NSString *tokenAccessKey;
@property NSInteger tokenExpiration;
@property NSString *client;
@property NSString *uid;
@property NSString *tokenType;
@property NSString *lastIP;
@property NSString *currentIP;

+ (instancetype)sessionWithEmail:(NSString *)email inRealm:(RLMRealm *)realm;
+ (instancetype)sessionWithEmail:(NSString *)email;

@end
RLM_ARRAY_TYPE(ALMSession)