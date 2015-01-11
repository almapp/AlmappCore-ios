//
//  ALMPlace.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMPlace.h"
#import "ALMArea.h"
#import "ALMResourceConstants.h"

@implementation ALMPlace

@synthesize comments = _comments, likes = _likes;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]   : kRResourceID,
             [self jatt:kAName]         : kRName,
             [self jatt:kAIdentifier]   : kRIdentifier,
             [self jatt:kAIsService]    : kRIsService,
             [self jatt:kAZoom]         : kRZoom,
             [self jatt:kAAngle]        : kRAngle,
             [self jatt:kATilt]         : kRTilt,
             [self jatt:kALatitude]     : kRLatitude,
             [self jatt:kALongitude]    : kRLongitude,
             [self jatt:kAFloor]        : kRFloor,
             [self jatt:kAInformation]  : kRInformation,
             [self jatt:kAUpdatedAt]    : kRUpdatedAt,
             [self jatt:kACreatedAt]    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                     : kRDefaultNullString,
             kRInformation              : kRDefaultNullString,
             kRIsService                : @NO,
             kRPolymorphicAreaType      : kRDefaultPolymorphicType,
             kRPolymorphicAreaID        : @0,
             kRFloor                    : kRDefaultUnknownFloor,
             kRZoom                     : @0.0f,
             kRTilt                     : @0.0f,
             kRAngle                    : @0.0f,
             kRLatitude                 : @0.0f,
             kRLongitude                : @0.0f,
             kRUpdatedAt                : [NSDate distantPast],
             kRCreatedAt                : [NSDate distantPast]
             };
}

- (void)setArea:(ALMArea *)area {
    [self setAreaID:area.resourceID];
    [self setAreaType:area.className];
}

- (ALMArea *)area {
    Class areaClass = NSClassFromString(self.areaType);
    return [ALMResource objectInRealm:[self realm] ofType:areaClass withID:self.areaID];
}

- (NSUInteger)positiveLikeCount {
    return [ALMLike positiveLikeCountFor:self];
}

- (NSUInteger)negativeLikeCount {
    return [ALMLike negativeLikeCountFor:self];
}

//+ (NSValueTransformer *)nameJSONTransformer {
//    return [MCJSONNonNullStringTransformer valueTransformer];
//}

@end