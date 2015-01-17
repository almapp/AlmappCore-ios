//
//  ALMArea.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMArea.h"
#import "ALMResourceConstants.h"

@implementation ALMArea

@synthesize localization = _localization;
@synthesize comments = _comments, likes = _likes, posts = _posts, publishedPosts = _publishedPosts, events = _events;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]   : kRResourceID,
             [self jatt:kAName]         : kRName,
             [self jatt:kAShortName]    : kRShortName,
             [self jatt:kAAbbreviation] : kRAbbreviation,
             [self jatt:kAAddress]      : kRAddress,
             [self jatt:kAEmail]        : kREmail,
             [self jatt:kAURL]          : kRURL,
             [self jatt:kAFacebookURL]  : kRFacebookURL,
             [self jatt:kATwitterURL]   : kRTwitterURL,
             [self jatt:kAPhone]        : kRPhone,
             [self jatt:kAInformation]  : kRInformation,
             [self jatt:kAUpdatedAt]    : kRUpdatedAt,
             [self jatt:kACreatedAt]    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                     : kRDefaultNullString,
             kRShortName                : kRDefaultNullString,
             kRAbbreviation             : kRDefaultNullString,
             kRAddress                  : kRDefaultNullString,
             kREmail                    : kRDefaultNullString,
             kRURL                      : kRDefaultNullString,
             kRFacebookURL              : kRDefaultNullString,
             kRTwitterURL               : kRDefaultNullString,
             kRPhone                    : kRDefaultNullString,
             kRInformation              : kRDefaultNullString,
             kRUpdatedAt                : [NSDate defaultDate],
             kRCreatedAt                : [NSDate defaultDate]
             };
}

+ (NSDictionary *)JSONNestedResourceInboundMappingDictionary {
    return @{
             kALocalization: kRLocalization
             };
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    if ([kr isEqualToString:kRLocalization]) {
        return [ALMPlace class];
    }
    else {
        return [super propertyTypeForKRConstant:kr];
    }
}

+ (NSString *)nameWhenAssociatedWith:(Class)associatedClass {
    if (associatedClass == [ALMPlace class]) {
        return kRPolymorphicArea;
    }
    else {
        return [super nameWhenAssociatedWith:associatedClass];
    }
}

+ (ALMPersistMode)persistMode {
    return ALMPersistModeForever;
}

- (NSUInteger)positiveLikeCount {
    return [ALMLike positiveLikeCountFor:self];
}

- (NSUInteger)negativeLikeCount {
    return [ALMLike negativeLikeCountFor:self];
}

@end
