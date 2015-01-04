//
//  ALMEvent.m
//  AlmappCore
//
//  Created by Patricio López on 03-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEvent.h"
#import "ALMResourceConstants.h"

@implementation ALMEvent

@synthesize comments = _comments, likes = _likes;

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
             [self jatt:kAUpdatedAt]    : kRUpdatedAt,
             [self jatt:kACreatedAt]    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRTitle                    : kRDefaultNullString,
             kRIsPrivate                : @NO,
             kRInformation              : kRDefaultNullString,
             kRPublishDate              : [NSDate distantPast],
             kRFromDate                 : [NSDate distantPast],
             kRToDate                   : [NSDate distantPast],
             kRPolymorphicHostType      : kRDefaultPolymorphicType,
             kRPolymorphicHostID        : @0,
             kRFacebookURL              : kRDefaultNullString,
             kRURL                      : kRDefaultNullString,
             kRUpdatedAt                : [NSDate distantPast],
             kRCreatedAt                : [NSDate distantPast]
             };
}

- (void)setHost:(ALMResource *)host {
    [self setHostID:host.resourceID];
    [self setHostType:host.className];
}

- (id)host {
    Class hostClass = NSClassFromString(self.hostType);
    return [ALMResource objectInRealm:[self realm] ofType:hostClass withID:self.hostID];
}

- (NSUInteger)positiveLikeCount {
    return [ALMLike positiveLikeCountFor:self];
}

- (NSUInteger)negativeLikeCount {
    return [ALMLike negativeLikeCountFor:self];
}

@end
