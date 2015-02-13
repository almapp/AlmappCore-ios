//
//  ALMCoreModule.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMCoreModuleDelegate.h"

@interface ALMCoreModule : NSObject

- (ALMSessionManager *)sessionManager;
- (ALMSession *)currentSession;
- (ALMApiKey *)apiKey;
- (NSString *)organizationSlug;

- (id)initWithCoreModuleDelegate:(id<ALMCoreModuleDelegate>)delegate;

- (RLMRealm *)realmNamed:(NSString *)name;
- (RLMRealm *)defaultRealm;
- (RLMRealm *)temporalRealm;
- (RLMRealm *)encryptedRealm;

@end
