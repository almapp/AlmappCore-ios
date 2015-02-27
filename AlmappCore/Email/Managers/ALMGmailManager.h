//
//  ALMGmailManager.h
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailManager.h"
#import "ALMEmail.h"
#import "ALMApiKey.h"

#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <GTLGmailConstants.h>

extern NSString *const kGmailProvider;

extern NSString *const kGmailLabelINBOX;
extern NSString *const kGmailLabelSPAM;
extern NSString *const kGmailLabelTRASH;
extern NSString *const kGmailLabelUNREAD;
extern NSString *const kGmailLabelSTARRED;
extern NSString *const kGmailLabelIMPORTANT;

@interface ALMGmailManager : ALMEmailManager

@property (strong, nonatomic) NSString *scope;
@property (strong, nonatomic) ALMApiKey *apiKey;

@property (readonly) ALMEmailFolder *inboxFolder;
@property (readonly) ALMEmailFolder *sentFolder;
@property (readonly) ALMEmailFolder *starredFolder;
@property (readonly) ALMEmailFolder *spamFolder;
@property (readonly) ALMEmailFolder *threadFolder;

- (PMKPromise *)setFirstAuthentication:(GTMOAuth2Authentication *)auth;
- (PMKPromise *)fetchEmailsInFolder:(ALMEmailFolder *)folder;

@end
