//
//  ALMUser.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMUser.h"
#import "ALMResourceConstants.h"
#import "ALMSection.h"
#import "ALMEvent.h"
#import "ALMGroup.h"

@implementation ALMUser

@synthesize publishedPosts = _publishedPosts;

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
             [self jatt:kALastSignIn]     : kRLastSignIn,
             [self jatt:kACurrentSignIn]  : kRCurrentSignIn,
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
             kRLastSignIn                 : [NSDate defaultDate],
             kRCurrentSignIn              : [NSDate defaultDate],
             kRUpdatedAt                  : [NSDate defaultDate],
             kRCreatedAt                  : [NSDate defaultDate]
             };
}

- (NSArray *)sections {
    return [self linkingObjectsOfClass:[ALMSection className] forProperty:kRStudents];
}

- (NSArray *)subscribedGroups {
    return [self linkingObjectsOfClass:[ALMGroup className] forProperty:kRSubscribers];
}

- (NSArray *)attendingEvents {
    return [self linkingObjectsOfClass:[ALMEvent className] forProperty:kRParticipants];
}

@end
