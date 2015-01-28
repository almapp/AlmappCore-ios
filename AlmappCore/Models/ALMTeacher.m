//
//  ALMTeacher.m
//  AlmappCore
//
//  Created by Patricio López on 19-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMTeacher.h"
#import "ALMResourceConstants.h"
#import "ALMAcademicUnity.h"
#import "ALMSection.h"

@implementation ALMTeacher

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kAName]             : kRName,
             [self jatt:kAEmail]            : kREmail,
             [self jatt:kAURL]              : kRURL,
             [self jatt:kAInformation]      : kRInformation,
             [self jatt:kAUpdatedAt]        : kRUpdatedAt,
             [self jatt:kACreatedAt]        : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                         : kRDefaultNullString,
             kREmail                        : kRDefaultNullString,
             kRURL                          : kRDefaultNullString,
             kRInformation                  : kRDefaultNullString,
             kRUpdatedAt                    : [NSDate defaultDate],
             kRCreatedAt                    : [NSDate defaultDate]
             };
}

@end
