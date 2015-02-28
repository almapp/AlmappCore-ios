//
//  ALMEmailToken.m
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailToken.h"
#import "ALMSession.h"
#import "ALMEmailConstants.h"
#import "ALMResourceConstants.h"

@implementation ALMEmailToken

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{@"email_token.provider" : kEmailProvider,
             @"email_token.access_token" : kEmailAccessToken,
             @"email_token.expires_at" : kEmailExpiresAt,
             @"email_token.created_at" : kRCreatedAt,
             @"email_token.updated_at" : kRUpdatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{kEmailEmail: kRDefaultNullString,
             kEmailProvider : kRDefaultNullString,
             kEmailAccessToken : kRDefaultNullString,
             kEmailExpiresAt : [NSDate distantPast],
             kRCreatedAt : [NSDate distantPast],
             kRUpdatedAt : [NSDate distantPast]
             };
}

+ (NSString *)primaryKey {
    return kEmailEmail;
}

- (BOOL)isExpired {
    return [self.expiresAt compare:[NSDate date]] == NSOrderedAscending;
}

- (ALMSession *)session {
    return [ALMSession sessionWithEmail:self.email];
}

@end
