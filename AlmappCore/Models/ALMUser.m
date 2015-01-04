//
//  ALMUser.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMUser.h"
#import "ALMResourceConstants.h"

@implementation ALMUser

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]     : kRResourceID,
             [self jatt:kAName]           : kRName,
             [self jatt:kAUsername]       : kRUsername,
             [self jatt:kAEmail]          : kREmail,
             [self jatt:kAMale]           : kRMale,
             [self jatt:kAStudentID]      : kRStudentID,
             [self jatt:kACountry]        : kRCountry,
             [self jatt:kAFindeable]      : kRFindeable,
             [self jatt:kALastSeen]       : kRLastSeen,
             [self jatt:kAUpdatedAt]      : kRUpdatedAt,
             [self jatt:kACreatedAt]      : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                       : kRDefaultNullString,
             kRMale                       : @YES,
             kRStudentID                  : kRDefaultNullString,
             kRCountry                    : kRDefaultNullString,
             kRFindeable                  : @YES,
             kRLastSeen                   : [NSDate distantPast],
             kRUpdatedAt                  : [NSDate distantPast],
             kRCreatedAt                  : [NSDate distantPast]
             };
}

//+ (NSValueTransformer *)nameJSONTransformer {
//    return [MCJSONNonNullStringTransformer valueTransformer];
//}

@end
