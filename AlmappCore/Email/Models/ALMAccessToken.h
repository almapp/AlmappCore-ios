//
//  ALMAccessToken.h
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "RLMObject.h"

@interface ALMAccessToken : RLMObject

@property NSString *accessToken;
@property NSDate *expiresIn;

@property (readonly) BOOL isExpired;

@end
