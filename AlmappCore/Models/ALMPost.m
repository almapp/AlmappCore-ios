//
//  ALMPost.m
//  AlmappCore
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMPost.h"
#import "ALMResourceConstants.h"
#import "ALMUser.h"
#import "ALMPlace.h"
#import "ALMEvent.h"

@implementation ALMPost

@synthesize localization = _localization;
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
             kRUpdatedAt                        : [NSDate defaultDate],
             kRCreatedAt                        : [NSDate defaultDate]
             };
}

+ (NSDictionary *)JSONNestedResourceInboundMappingDictionary {
    return @{
             kAUser : kRUser,
             kAPolymorphicPostTargetable : kRPolymorphicPostTargetable,
             kAPolymorphicPostPublisher : kRPolymorphicPostPublisher,
             kALocalization: kRLocalization,
             kAEvent : kREvent
             };
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    if([kr isEqualToString:kRUser]) {
        return [ALMUser class];
    }
    else if ([kr isEqualToString:kRLocalization]) {
        return [ALMPlace class];
    }
    else if ([kr isEqualToString:kREvent]) {
        return [ALMEvent class];
    }
    else {
        return [super propertyTypeForKRConstant:kr];
    }
}

+ (NSArray *)polymorphicNestedResourcesKeys {
    return @[kAPolymorphicPostTargetable, kAPolymorphicPostPublisher];
}

- (void)setEntity:(ALMResource<ALMPostPublisher> *)entity {
    [self setEntityID:[entity resourceID]];
    [self setEntityType:[entity className]];
}

- (ALMResource<ALMPostPublisher>*)entity {
    Class entityClass = NSClassFromString(self.entityType);
    return [entityClass objectInRealm:self.realm forID:self.entityID];
}

- (void)setTarget:(ALMResource<ALMPostTargetable> *)target {
    [self setTargetID:[target resourceID]];
    [self setTargetType:[target className]];
}

- (id)target {
    Class targetClass = NSClassFromString(self.targetType);
    return [targetClass objectInRealm:self.realm forID:self.targetID];
}

- (NSUInteger)positiveLikeCount {
    return [ALMLike positiveLikeCountFor:self];
}

- (NSUInteger)negativeLikeCount {
    return [ALMLike negativeLikeCountFor:self];
}

@end
