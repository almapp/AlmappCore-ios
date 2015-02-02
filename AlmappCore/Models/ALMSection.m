//
//  ALMSection.m
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSection.h"
#import "ALMCourse.h"
#import "ALMScheduleItem.h"
#import "ALMUser.h"
#import "ALMResourceConstants.h"

@implementation ALMSection

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kAIdentifier]       : kRIdentifier,
             [self jatt:kAVacancy]          : kRVacancy,
             [self jatt:kASectionNumber]    : kRSectionNumber,
             [self jatt:kAYear]             : kRYear,
             [self jatt:kAPeriod]           : kRPeriod,
             [self jatt:kAUpdatedAt]        : kRUpdatedAt,
             [self jatt:kACreatedAt]        : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRIdentifier               : kRDefaultNullString,
             kRVacancy                  : @0,
             kRSectionNumber            : @0,
             kRYear                     : @0,
             kRPeriod                   : @0,
             kRUpdatedAt                : [NSDate defaultDate],
             kRCreatedAt                : [NSDate defaultDate]
             };
}

+ (NSDictionary *)JSONNestedResourceInboundMappingDictionary {
    return @{
             [ALMCourse apiSingleForm] : [ALMCourse realmSingleForm]
             };
}

+ (NSDictionary *)JSONNestedResourceCollectionInboundMappingDictionary {
    return @{
             [ALMScheduleItem apiPluralForm] : [ALMScheduleItem realmPluralForm],
             [ALMTeacher apiPluralForm] : [ALMTeacher realmPluralForm],
             @"assistants" : kRStudents
             };
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    if([kr isEqualToString:kRStudents]) {
        return [ALMUser class];
    }
    else if ([kr isEqualToString:[ALMTeacher realmPluralForm]]) {
        return [ALMTeacher class];
    }
    else if ([kr isEqualToString:[ALMScheduleItem realmPluralForm]]) {
        return [ALMScheduleItem class];
    }
    else if ([kr isEqualToString:[ALMCourse realmSingleForm]]) {
        return [ALMCourse class];
    }
    else {
        return [super propertyTypeForKRConstant:kr];
    }
}


@end
