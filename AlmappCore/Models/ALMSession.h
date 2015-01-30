//
//  ALMSession.h
//  AlmappCore
//
//  Created by Patricio López on 20-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMUser.h"
#import "ALMCredential.h"

@interface ALMSession : RLMObject

@property NSString *email;

@property ALMUser *user;
@property NSString *lastIP;
@property NSString *currentIP;
@property ALMCredential *credential;

+ (instancetype)sessionWithEmail:(NSString *)email inRealm:(RLMRealm *)realm;
+ (instancetype)sessionWithEmail:(NSString *)email;

@end
RLM_ARRAY_TYPE(ALMSession)