//
//  ALMLike.m
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMLike.h"
#import "ALMResourceConstants.h"
#import "ALMLikeable.h"

@implementation ALMLike

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kAValuation]        : kRTitle
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRValuation                    : @0,
             kRPolymorphicLikeableType      : kRDefaultPolymorphicType,
             kRPolymorphicLikeableID        : kRDefaultPolymorphicID
             };
}

- (void)setLikeable:(ALMResource<ALMLikeable>*)likeable {
    [self setLikeableID:[likeable resourceID]];
    [self setLikeableType:[likeable className]];
}

- (ALMResource<ALMLikeable>*)likeable {
    Class likeableClass = NSClassFromString(self.likeableType);
    return [likeableClass objectInRealm:self.realm withID:self.likeableID];
}

+ (ALMPersistMode)persistMode {
    return ALMPersistModeNone;
}

#pragma mark - Like helpers

+ (RLMResults*)positiveLikesFor:(ALMResource<ALMLikeable> *)likeable {
    NSString *query = [NSString stringWithFormat:@"%@ = 1", kRValuation];
    return [[likeable likes] objectsWhere: query];
}

+ (RLMResults*)negativeLikesFor:(ALMResource<ALMLikeable> *)likeable {
    NSString *query = [NSString stringWithFormat:@"%@ = -1", kRValuation];
    return [[likeable likes] objectsWhere: query];
}

+(NSUInteger)positiveLikeCountFor:(ALMResource<ALMLikeable> *)likeable {
    return [self positiveLikesFor:likeable].count;
}

+ (NSUInteger)negativeLikeCountFor:(ALMResource<ALMLikeable> *)likeable {
    return [self negativeLikesFor:likeable].count;
}

@end
