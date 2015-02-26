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

- (PMKPromise *)saveAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken code:(NSString *)code expirationDate:(NSDate *)expirationDate {
    return nil;
}

- (PMKPromise *)getValidAccessToken {
    if (self.accessToken && !self.accessToken.isExpired) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
            fulfiller(self.accessToken);
        }];
    }
    else {
        return [self getForceAccessToken];
    }
}

- (PMKPromise *)getForceAccessToken {
    return nil;
}

@end
