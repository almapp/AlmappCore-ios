//
//  ALMEvent.m
//  AlmappCore
//
//  Created by Patricio López on 03-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEvent.h"
#import "ALMResourceConstants.h"
#import "ALMPlace.h"
#import "ALMUser.h"

@implementation ALMEvent

@synthesize localization = _localization;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]   : kRResourceID,
             [self jatt:kATitle]        : kRTitle,
             [self jatt:kAIsPrivate]    : kRIsPrivate,
             [self jatt:kAInformation]  : kRInformation,
             [self jatt:kAPublishDate]  : kRPublishDate,
             [self jatt:kAFromDate]     : kRFromDate,
             [self jatt:kAToDate]       : kRToDate,
             [self jatt:kAFacebookURL]  : kRFacebookURL,
             [self jatt:kAURL]          : kRURL,
             [self jatt:kALikesCount]     : kRLikesCount,
             [self jatt:kADislikesCount]  : kRDislikesCount,
             [self jatt:kACommentsCount]  : kRCommentsCount,
             [self jatt:kAUpdatedAt]    : kRUpdatedAt,
             [self jatt:kACreatedAt]    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRTitle                    : kRDefaultNullString,
             kRIsPrivate                : @NO,
             kRInformation              : kRDefaultNullString,
             kRPublishDate              : [NSDate defaultEventDate],
             kRFromDate                 : [NSDate defaultEventDate],
             kRToDate                   : [NSDate defaultEventDate],
             kRPolymorphicHostType      : kRDefaultPolymorphicType,
             kRPolymorphicHostID        : kRDefaultPolymorphicID,
             kRFacebookURL              : kRDefaultNullString,
             kRURL                      : kRDefaultNullString,
             kRLikesCount                   : @0,
             kRDislikesCount                : @0,
             kRCommentsCount                : @0,
             kRUpdatedAt                : [NSDate defaultEventDate],
             kRCreatedAt                : [NSDate defaultEventDate]
             };
}

+ (NSDictionary *)JSONNestedResourceInboundMappingDictionary {
    return @{
             kAUser                     : kRUser,
             kAPolymorphicHost          : kRPolymorphicHost,
             kALocalization             : kRLocalization,
             };
}

+ (NSDictionary *)JSONNestedResourceCollectionInboundMappingDictionary {
    return @{
             kAParticipants             : kRParticipants
             };
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    if([kr isEqualToString:kRUser]) {
        return [ALMUser class];
    }
    else if ([kr isEqualToString:kRLocalization]) {
        return [ALMPlace class];
    }
    else if ([kr isEqualToString:kRParticipants]) {
        return [ALMUser class];
    }
    else {
        return [super propertyTypeForKRConstant:kr];
    }
}

+ (NSArray *)polymorphicNestedResourcesKeys {
    return @[kAPolymorphicHost];
}

- (void)setHost:(ALMResource<ALMEventHost> *)host {
    [self setHostID:[host resourceID]];
    [self setHostType:[host className]];
}

- (ALMResource<ALMEventHost> *)host {
    Class hostClass = NSClassFromString(self.hostType);
    return [hostClass objectInRealm:self.realm withID:self.hostID];
}

@end
