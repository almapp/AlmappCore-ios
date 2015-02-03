//
//  ALMWebPage.h
//  AlmappCore
//
//  Created by Patricio López on 12-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"

@class ALMOrganization;

typedef NS_ENUM(NSUInteger, ALMWebPageType) {
    ALMWebPageTypeCommunity,
    ALMWebPageTypeOfficial,
    ALMWebPageTypePoliticalParty,
    ALMWebPageTypeUtility
};

@interface ALMWebPage : ALMResource

@property NSString *identifier;
@property NSString *name;
@property NSString *owner;
@property ALMOrganization *organization;
@property NSInteger pageType;
@property NSString *information;
@property BOOL isAvailable;
@property BOOL isSecureProtocol;
@property BOOL isLoginRequired;
@property BOOL shouldOpenInBrowser;
@property NSString* homeUrl;
@property NSString* loginUrl;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@end
RLM_ARRAY_TYPE(ALMWebPage)
