//
//  ALMSession.m
//  AlmappCore
//
//  Created by Patricio López on 20-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSession.h"
#import "ALMResourceConstants.h"
#import "ALMTemporalCredential.h"

@implementation ALMSession

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{ };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kREmail                    : kRDefaultNullString,
             @"lastIP"                  : kRDefaultNullString,
             @"currentIP"               : kRDefaultNullString,
             };
}

+ (NSArray *)ignoredProperties {
    return @[@"credential"];
}

+ (NSString *)primaryKey {
    return kREmail;
}

- (ALMCredential *)credential {
    if (!_credential) {
        _credential = [ALMCredential credentialForEmail:self.email];
    }
    return _credential;
}

+ (instancetype)sessionWithEmail:(NSString *)email password:(NSString *)password {
    return [self sessionWithEmail:email password:password inRealm:[RLMRealm defaultRealm]];
}

+ (instancetype)sessionWithEmail:(NSString *)email password:(NSString *)password inRealm:(RLMRealm *)realm {
    ALMSession *session = [self sessionWithEmail:email inRealm:realm];
    if (session) {
        return session;
    }
    
    [realm beginWriteTransaction];
    
    session = [[self alloc] init];
    session.email = email;
    session = [ALMSession createInRealm:realm withObject:session];

    [realm commitWriteTransaction];
    
    session.credential = [ALMTemporalCredential credentialForEmail:email password:password];
    return session;
}

+ (instancetype)sessionWithEmail:(NSString *)email {
    return [self sessionWithEmail:email inRealm:[RLMRealm defaultRealm]];
}

+ (instancetype)sessionWithEmail:(NSString *)email inRealm:(RLMRealm *)realm{
    return [self objectInRealm:realm forPrimaryKey:email];
    
    //NSString *query = [NSString stringWithFormat:@"%@ = '%@'", kREmail, email];
    //return [self objectsInRealm:realm where:query].firstObject;
}

@end
