//
//  ALMSession.m
//  AlmappCore
//
//  Created by Patricio López on 20-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSession.h"
#import "ALMResourceConstants.h"

@implementation ALMSession

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{ };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kREmail                    : kRDefaultNullString,
             @"password"                : kRDefaultNullString,
             @"tokenAccessKey"                       : kRDefaultNullString,
             @"tokenExpiration"                       : @0,
             @"client"                       : kRDefaultNullString,
             @"uid"                       : kRDefaultNullString,
             @"tokenType"                       : kRDefaultNullString,
             @"lastIP"                       : kRDefaultNullString,
             @"currentIP"                       : kRDefaultNullString,
             };
}

+ (instancetype)sessionWithEmail:(NSString *)email inRealm:(RLMRealm *)realm{
    NSString *query = [NSString stringWithFormat:@"%@ = '%@'", kREmail, email];
    return [self objectsInRealm:realm where:query].firstObject;
}

+ (instancetype)sessionWithEmail:(NSString *)email {
    return [self sessionWithEmail:email inRealm:[RLMRealm defaultRealm]];
}

@end
