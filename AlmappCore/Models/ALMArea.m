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
@synthesize posts = _posts, publishedPosts = _publishedPosts, events = _events;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]           : kRResourceID,
             [self jatt:kAName]                 : kRName,
             [self jatt:kAShortName]            : kRShortName,
             [self jatt:kAAbbreviation]         : kRAbbreviation,
             [self jatt:kAAddress]              : kRAddress,
             [self jatt:kABannerOriginalPath]   : kRBannerOriginalPath,
             [self jatt:kABannerSmallPath]      : kRBannerSmallPath,
             [self jatt:kAEmail]                : kREmail,
             [self jatt:kAURL]                  : kRURL,
             [self jatt:kAFacebookURL]          : kRFacebookURL,
             [self jatt:kATwitterURL]           : kRTwitterURL,
             [self jatt:kAPhone]                : kRPhone,
             [self jatt:kAInformation]          : kRInformation,
             [self jatt:kALikesCount]           : kRLikesCount,
             [self jatt:kADislikesCount]        : kRDislikesCount,
             [self jatt:kACommentsCount]        : kRCommentsCount,
             [self jatt:kAUpdatedAt]            : kRUpdatedAt,
             [self jatt:kACreatedAt]            : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                     : kRDefaultNullString,
             kRShortName                : kRDefaultNullString,
             kRAbbreviation             : kRDefaultNullString,
             kRAddress                  : kRDefaultNullString,
             kRBannerOriginalPath       : kRDefaultNullString,
             kRBannerSmallPath          : kRDefaultNullString,
             kREmail                    : kRDefaultNullString,
             kRURL                      : kRDefaultNullString,
             kRFacebookURL              : kRDefaultNullString,
             kRTwitterURL               : kRDefaultNullString,
             kRPhone                    : kRDefaultNullString,
             kRInformation              : kRDefaultNullString,
             kRLikesCount                   : @0,
             kRDislikesCount                : @0,
             kRCommentsCount                : @0,
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

- (RLMResults *)placesWithCategory:(ALMCategoryType)categoryType {
    RLMArray<ALMPlace> *places = self.places;
    NSString *query = [NSString stringWithFormat:@"ANY categories.category == %ld", (long)categoryType];
    return [places objectsWhere:query];
}

+ (ALMPersistMode)persistMode {
    return ALMPersistModeForever;
}

@end
