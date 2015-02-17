//
//  ALMCareer.m
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCareer.h"
#import "ALMAcademicUnity.h"
#import "ALMResourceConstants.h"

@implementation ALMCareer

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]   : kRResourceID,
             [self jatt:kAName]         : kRName,
             [self jatt:kAURL]          : kRURL,
             [self jatt:kAInformation]  : kRInformation,
             [self jatt:kALikesCount]     : kRLikesCount,
             [self jatt:kADislikesCount]  : kRDislikesCount,
             [self jatt:kACommentsCount]  : kRCommentsCount,
             [self jatt:kAUpdatedAt]    : kRUpdatedAt,
             [self jatt:kACreatedAt]    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                     : kRDefaultNullString,
             kRURL                      : kRDefaultNullString,
             kRInformation              : kRDefaultNullString,
             kRLikesCount                   : @0,
             kRDislikesCount                : @0,
             kRCommentsCount                : @0,
             kRUpdatedAt                : [NSDate defaultDate],
             kRCreatedAt                : [NSDate defaultDate]
             };
}

@end
