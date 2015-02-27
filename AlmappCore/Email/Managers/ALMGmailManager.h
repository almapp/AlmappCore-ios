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

@class ALMGmailManager;

@protocol ALMGmailDelegate <NSObject>

@required
- (GTMOAuth2Authentication *)gmailAuthenticationFor:(ALMGmailManager *)manager;
- (ALMApiKey *)gmailApiKey:(ALMGmailManager *)manager;
- (NSString *)gmailScope:(ALMGmailManager *)manager;

@end


@interface ALMGmailManager : ALMEmailManager


@property (weak, nonatomic) id<ALMGmailDelegate> delegate;

@property (readonly) ALMEmailFolder *inboxFolder;
@property (readonly) ALMEmailFolder *sentFolder;
@property (readonly) ALMEmailFolder *starredFolder;
@property (readonly) ALMEmailFolder *spamFolder;
@property (readonly) ALMEmailFolder *threadFolder;

- (PMKPromise *)setFirstAuthentication:(GTMOAuth2Authentication *)auth;
- (PMKPromise *)fetchEmailsInFolder:(ALMEmailFolder *)folder;

@end
