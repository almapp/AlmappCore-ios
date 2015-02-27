//
//  ALMEmailController.h
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <PromiseKit/Promise.h>

#import "ALMCustomController.h"
#import "ALMEmailToken.h"
#import "ALMEmailFolder.h"
#import "ALMEmailThread.h"
#import "ALMEmail.h"

@interface ALMEmailController : ALMCustomController

@property (readonly) ALMEmailToken *emailToken;

- (PMKPromise *)saveAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken code:(NSString *)code expirationDate:(NSDate *)expirationDate provider:(NSString *)provider;
- (PMKPromise *)getForceAccessToken;
- (PMKPromise *)getValidAccessToken;
- (BOOL)isAccessTokenValid;

- (ALMEmailFolder *)folder:(NSString *)identifier;
- (void)saveLastMails:(NSInteger)count on:(ALMEmailFolder *)folder;

@end
