//
//  ALMEmailToken.m
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailToken.h"
#import "ALMSession.h"

@implementation ALMEmailToken

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{@"email_token.provider" : @"provider",
             @"email_token.access_token" : @"accessToken",
             @"email_token.expires_at" : @"expiresAt",
             @"email_token.created_at" : @"updatedAt",
             @"email_token.updated_at" : @"createdAt"
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"email" : @"",
             @"provider" : @"",
             @"accessToken" : @"",
             @"expiresAt" : [NSDate distantPast],
             @"updatedAt" : [NSDate distantPast],
             @"createdAt" : [NSDate distantPast]
             };
}

+ (NSString *)primaryKey {
    return @"email";
}

- (BOOL)isExpired {
    return [self.expiresAt compare:[NSDate date]] == NSOrderedAscending;
}

- (ALMSession *)session {
    return [ALMSession sessionWithEmail:self.email];
}

@end
