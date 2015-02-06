//
//  ALMCourse.m
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCourse.h"
#import "ALMAcademicUnity.h"
#import "ALMResourceConstants.h"

@implementation ALMCourse

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]   : kRResourceID,
             [self jatt:kAInitials]     : kRInitials,
             [self jatt:kAName]         : kRName,
             [self jatt:kACredits]      : kRCredits,
             [self jatt:kAIsAvailable]  : kRIsAvailable,
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
             kRInitials                 : kRDefaultNullString,
             kRName                     : kRDefaultNullString,
             kRCredits                  : @0,
             kRIsAvailable              : @YES,
             kRInformation              : kRDefaultNullString,
             kRLikesCount                   : @0,
             kRDislikesCount                : @0,
             kRCommentsCount                : @0,
             kRUpdatedAt                : [NSDate defaultDate],
             kRCreatedAt                : [NSDate defaultDate]
             };
}

- (ALMAcademicUnity *)academicUnity {
    return [self linkingObjectsOfClass:[ALMAcademicUnity className] forProperty:self.realmPluralForm].firstObject;
}

- (RLMResults *)sectionsOnYear:(short)year period:(short)period {
    return [self.sections objectsWithPredicate:[NSPredicate predicateWithFormat:@"%@ = %@ AND %@ = %@", kRYear, year, kRPeriod, period]];
}

@end
