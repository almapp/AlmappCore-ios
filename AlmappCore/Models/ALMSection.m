//
//  ALMSection.m
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSection.h"
#import "ALMCourse.h"
#import "ALMResourceConstants.h"

@implementation ALMSection

@synthesize likes = _likes, comments = _comments;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kASectionNumber]    : kRSectionNumber,
             [self jatt:kAYear]             : kRYear,
             [self jatt:kAPeriod]           : kRPeriod,
             [self jatt:kAUpdatedAt]        : kRUpdatedAt,
             [self jatt:kACreatedAt]        : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRSectionNumber            : @0,
             kRYear                     : @0,
             kRPeriod                   : @0,
             kRUpdatedAt                : [NSDate defaultDate],
             kRCreatedAt                : [NSDate defaultDate]
             };
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    if([kr isEqualToString:kRStudents]) {
        return [ALMUser class];
    }
    else {
        return [super propertyTypeForKRConstant:kr];
    }
}

- (ALMCourse *)course {
    return [self linkingObjectsOfClass:[ALMCourse className] forProperty:self.realmPluralForm].firstObject;
}

- (NSUInteger)positiveLikeCount {
    return [ALMLike positiveLikeCountFor:self];
}

- (NSUInteger)negativeLikeCount {
    return [ALMLike negativeLikeCountFor:self];
}

@end
