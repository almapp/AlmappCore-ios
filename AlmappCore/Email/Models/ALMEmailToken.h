//
//  ALMEmailToken.h
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "RLMObject.h"

@class ALMSession;

@interface ALMEmailToken : RLMObject

@property NSString *email;
@property NSString *provider;
@property NSString *accessToken;
@property NSDate *expiresAt;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@property (readonly) BOOL isExpired;
@property (readonly) ALMSession *session;

@end
