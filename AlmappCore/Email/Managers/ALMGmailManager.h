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


@class ALMGmailManager;

@protocol ALMGmailDelegate <NSObject>

@required
- (GTMOAuth2Authentication *)gmailAuthenticationFor:(ALMGmailManager *)manager;

@end


@interface ALMGmailManager : ALMEmailManager


@property (weak, nonatomic) id<ALMGmailDelegate> delegate;

- (PMKPromise *)setFirstAuthentication:(GTMOAuth2Authentication *)auth;

@end
