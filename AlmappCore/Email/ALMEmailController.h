//
//  ALMEmailController.h
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCustomController.h"
#import "ALMAccessToken.h"
#import <PromiseKit/Promise.h>

@interface ALMEmailController : ALMCustomController

@property (strong, nonatomic) ALMAccessToken *accessToken;

- (PMKPromise *)saveAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken code:(NSString *)code expirationDate:(NSDate *)expirationDate;
- (PMKPromise *)getForceAccessToken;
- (PMKPromise *)getValidAccessToken;

@end
