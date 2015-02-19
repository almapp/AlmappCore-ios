//
//  ALMWebPage.m
//  AlmappCore
//
//  Created by Patricio López on 12-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMWebPage.h"
#import "ALMResourceConstants.h"
#import "ALMOrganization.h"

@implementation ALMWebPage

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]               : kRResourceID,
             [self jatt:kAIdentifier]               : kRIdentifier,
             [self jatt:kAName]                     : kRName,
             [self jatt:kAOwner]                    : kROwner,
             [self jatt:kAIconOriginalPath]         : kRIconOriginalPath,
             [self jatt:kABackgroundOriginalPath]   : kRBackgroundOriginalPath,
             [self jatt:kAPageType]                 : kRPageType,
             [self jatt:kAInformation]              : kRInformation,
             [self jatt:kAIsAvailable]              : kRIsAvailable,
             [self jatt:kAIsSecureProtocol]         : kRIsSecureProtocol,
             [self jatt:kAIsLoginRequired]          : kRIsLoginRequired,
             [self jatt:kAShouldOpenInBrowser]      : kRShouldOpenInBrowser,
             [self jatt:kAHomeUrl]                  : kRHomeUrl,
             [self jatt:kALoginUrl]                 : kRLoginUrl,
             [self jatt:kAUpdatedAt]                : kRUpdatedAt,
             [self jatt:kACreatedAt]                : kRCreatedAt
             };
}

+ (NSValueTransformer *)pageTypeJSONTransformer {
    return [MCJSONValueTransformer valueTransformerWithMappingDictionary:@{
                                                                           @"community": @(ALMWebPageTypeCommunity),
                                                                           @"official": @(ALMWebPageTypeOfficial),
                                                                           @"political_party": @(ALMWebPageTypePoliticalParty),
                                                                           @"utility": @(ALMWebPageTypeUtility)
                                                                           }];
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kROwner                    : kRDefaultNullString,
             kRInformation              : kRDefaultNullString,
             kRLoginUrl                 : kRDefaultNullString,
             kRHomeUrl                  : kRDefaultNullString,
             kRIconOriginalPath         : kRDefaultNullString,
             kRBackgroundOriginalPath   : kRDefaultNullString,
             kRUpdatedAt                : [NSDate defaultDate],
             kRCreatedAt                : [NSDate defaultDate]
             };
}

@end
