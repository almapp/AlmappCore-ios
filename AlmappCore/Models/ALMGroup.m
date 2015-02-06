//
//  ALMGroup.m
//  AlmappCore
//
//  Created by Patricio López on 15-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMGroup.h"
#import "ALMUser.h"
#import "ALMResourceConstants.h"

@implementation ALMGroup

@synthesize posts = _posts, publishedPosts = _publishedPosts;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]     : kRResourceID,
             [self jatt:kAName]           : kRName,
             [self jatt:kAEmail]          : kREmail,
             [self jatt:kAURL]            : kRURL,
             [self jatt:kAFacebookURL]    : kRFacebookURL,
             [self jatt:kATwitterURL]     : kRTwitterURL,
             [self jatt:kAInformation]    : kRInformation,
             [self jatt:kALikesCount]     : kRLikesCount,
             [self jatt:kADislikesCount]  : kRDislikesCount,
             [self jatt:kACommentsCount]  : kRCommentsCount,
             [self jatt:kAUpdatedAt]      : kRUpdatedAt,
             [self jatt:kACreatedAt]      : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                       : kRDefaultNullString,
             kREmail                      : kRDefaultNullString,
             kRURL                        : kRDefaultNullString,
             kRFacebookURL                : kRDefaultNullString,
             kRTwitterURL                 : kRDefaultNullString,
             kRLikesCount                   : @0,
             kRDislikesCount                : @0,
             kRCommentsCount                : @0,
             kRInformation                : [NSDate defaultDate],
             kRUpdatedAt                  : [NSDate defaultDate],
             kRCreatedAt                  : [NSDate defaultDate]
             };
}

+ (NSDictionary *)JSONNestedResourceCollectionInboundMappingDictionary {
    return @{
             kASubscribers             : kRSubscribers
             };
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    if([kr isEqualToString:kRSubscribers]) {
        return [ALMUser class];
    }
    else {
        return [super propertyTypeForKRConstant:kr];
    }
}

@end
