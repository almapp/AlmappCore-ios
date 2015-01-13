//
//  ALMPost.m
//  AlmappCore
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMPost.h"
#import "ALMResourceConstants.h"

@implementation ALMPost

@synthesize likes = _likes, comments = _comments;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kAContent]          : kRContent,
             [self jatt:kAIsHidden]         : kRIsHidden,
             [self jatt:kAShouldNotify]     : kRShouldNotify,
             [self jatt:kAUpdatedAt]        : kRUpdatedAt,
             [self jatt:kACreatedAt]        : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRContent                          : kRDefaultNullString,
             kRIsHidden                         : @NO,
             kRShouldNotify                     : @NO,
             kRPolymorphicPostPublisherType     : kRDefaultPolymorphicType,
             kRPolymorphicPostPublisherID       : kRDefaultPolymorphicID,
             kRPolymorphicPostTargetableType    : kRDefaultPolymorphicType,
             kRPolymorphicPostTargetableID      : kRDefaultPolymorphicID,
             kRUpdatedAt                        : [NSDate distantPast],
             kRCreatedAt                        : [NSDate distantPast]
             };
}


- (void)setEntity:(ALMResource<ALMPostPublisher> *)entity {
    [self setEntityID:[entity resourceID]];
    [self setEntityType:[entity className]];
}

- (ALMResource<ALMPostPublisher>*)entity {
    Class entityClass = NSClassFromString(self.entityType);
    return [ALMResource objectInRealm:[self realm] ofType:entityClass withID:self.entityID];
}

- (void)setTarget:(ALMResource<ALMPostTargetable> *)target {
    [self setTargetID:[target resourceID]];
    [self setTargetType:[target className]];
}

- (id)target {
    Class targetClass = NSClassFromString(self.targetType);
    return [ALMResource objectInRealm:[self realm] ofType:targetClass withID:self.targetID];
}

- (NSUInteger)positiveLikeCount {
    return [ALMLike positiveLikeCountFor:self];
}

- (NSUInteger)negativeLikeCount {
    return [ALMLike negativeLikeCountFor:self];
}

@end
