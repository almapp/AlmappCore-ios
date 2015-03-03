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

extern NSInteger const kGmailDefaultResultsPerPage;
extern NSString *const kGmailProvider;

extern NSString *const kGmailLabelINBOX;
extern NSString *const kGmailLabelSENT;
extern NSString *const kGmailLabelDRAFT;
extern NSString *const kGmailLabelSPAM;
extern NSString *const kGmailLabelTRASH;
extern NSString *const kGmailLabelUNREAD;
extern NSString *const kGmailLabelSTARRED;
extern NSString *const kGmailLabelIMPORTANT;

@class ALMGmailManager;

@protocol ALMGmailDelegate <NSObject>

- (void)gmailManager:(ALMGmailManager *)manager tokenNotFound:(NSError *)error;

@end

@interface ALMGmailManager : ALMEmailManager

@property (strong, nonatomic) RLMRealm *realm;

@property (weak, nonatomic) id<ALMGmailDelegate> delegate;
@property (strong, nonatomic) NSString *scope;
@property (strong, nonatomic) ALMApiKey *apiKey;

@property (readonly) NSArray *inboxFolder;
@property (readonly) NSArray *sentFolder;
@property (readonly) NSArray *starredFolder;
@property (readonly) NSArray *spamFolder;
@property (readonly) NSArray *trashFolder;

- (PMKPromise *)setFirstAuthentication:(GTMOAuth2Authentication *)auth;

- (PMKPromise *)fetchThreadsWithEmailsLabeled:(ALMEmailLabel)labels count:(NSInteger)count;
- (PMKPromise *)fetchThreadsWithEmailsLabeled:(ALMEmailLabel)labels count:(NSInteger)count pageToken:(NSString *)pageToken;;


- (PMKPromise *)markThreadAsReaded:(ALMEmailThread *)thread readed:(BOOL)readed;
- (PMKPromise *)markThreadsAsReaded:(NSArray *)threads readed:(BOOL)readed;

- (PMKPromise *)markEmailAsReaded:(ALMEmail *)email readed:(BOOL)readed;
- (PMKPromise *)markEmailsAsReaded:(NSArray *)emails readed:(BOOL)readed;


- (PMKPromise *)starThread:(ALMEmailThread *)thread starred:(BOOL)starred;
- (PMKPromise *)starThreads:(NSArray *)threads starred:(BOOL)starred;

- (PMKPromise *)starEmail:(ALMEmail *)email starred:(BOOL)starred;
- (PMKPromise *)starEmails:(NSArray *)emails starred:(BOOL)starred;


- (PMKPromise *)deleteThread:(ALMEmailThread *)thread markAsReaded:(BOOL)markAsReaded;
- (PMKPromise *)deleteThreads:(NSArray *)threads markAsReaded:(BOOL)markAsReaded;

- (PMKPromise *)deleteEmail:(ALMEmail *)email markAsReaded:(BOOL)markAsReaded;
- (PMKPromise *)deleteEmails:(NSArray *)emails markAsReaded:(BOOL)markAsReaded;


- (PMKPromise *)modifyEmails:(NSArray *)emails addLabels:(NSArray *)addLabels removeLabels:(NSArray *)removeLabels;

- (void)signOut;
- (BOOL)isSignedIn;

@end
