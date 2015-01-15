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

@synthesize comments = _comments, likes = _likes;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]   : kRResourceID,
             [self jatt:kAName]         : kRTitle,
             [self jatt:kAURL]          : kRURL,
             [self jatt:kACurriculumURL]: kRCurriculumURL,
             [self jatt:kAInformation]  : kRInformation,
             [self jatt:kAUpdatedAt]    : kRUpdatedAt,
             [self jatt:kACreatedAt]    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                     : kRDefaultNullString,
             kRURL                      : kRDefaultNullString,
             kRCurriculumURL            : kRDefaultNullString,
             kRInformation              : kRDefaultNullString,
             kRUpdatedAt                : [NSDate defaultDate],
             kRCreatedAt                : [NSDate defaultDate]
             };
}

- (NSUInteger)positiveLikeCount {
    return [ALMLike positiveLikeCountFor:self];
}

- (NSUInteger)negativeLikeCount {
    return [ALMLike negativeLikeCountFor:self];
}

@end
