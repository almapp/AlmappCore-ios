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

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]   : kRResourceID,
             [self jatt:kAName]         : kRName,
             [self jatt:kAIdentifier]   : kRIdentifier,
             [self jatt:kAZoom]         : kRZoom,
             [self jatt:kAAngle]        : kRAngle,
             [self jatt:kATilt]         : kRTilt,
             [self jatt:kALatitude]     : kRLatitude,
             [self jatt:kALongitude]    : kRLongitude,
             [self jatt:kAFloor]        : kRFloor,
             [self jatt:kAInformation]  : kRInformation,
             [self jatt:kALikesCount]     : kRLikesCount,
             [self jatt:kADislikesCount]  : kRDislikesCount,
             [self jatt:kACommentsCount]  : kRCommentsCount,
             [self jatt:kAUpdatedAt]    : kRUpdatedAt,
             [self jatt:kACreatedAt]    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                     : kRDefaultNullString,
             kRInformation              : kRDefaultNullString,
             kRPolymorphicAreaType      : kRDefaultPolymorphicType,
             kRPolymorphicAreaID        : kRDefaultPolymorphicID,
             kRFloor                    : kRDefaultUnknownFloor,
             kRZoom                     : @0.0f,
             kRTilt                     : @0.0f,
             kRAngle                    : @0.0f,
             kRLatitude                 : @0.0f,
             kRLongitude                : @0.0f,
             kRLikesCount                   : @0,
             kRDislikesCount                : @0,
             kRCommentsCount                : @0,
             kRUpdatedAt                : [NSDate defaultDate],
             kRCreatedAt                : [NSDate defaultDate]
             };
}

+ (NSDictionary *)JSONNestedResourceCollectionInboundMappingDictionary {
    return @{
             @"categories"             : @"categories"
             };
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    if([kr isEqualToString:@"categories"]) {
        return [ALMCategory class];
    }
    else {
        return [super propertyTypeForKRConstant:kr];
    }
}

- (void)setArea:(ALMArea *)area {
    [self setAreaID:[area resourceID]];
    [self setAreaType:[area className]];
}

- (ALMArea *)area {
    Class areaClass = NSClassFromString(self.areaType);
    return [areaClass objectInRealm:self.realm withID:self.areaID];
}

//+ (NSValueTransformer *)nameJSONTransformer {
//    return [MCJSONNonNullStringTransformer valueTransformer];
//}

@end