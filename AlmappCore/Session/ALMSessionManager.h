//
//  ALMSessionManager.h
//  AlmappCore
//
//  Created by Patricio López on 20-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Realm/Realm.h>
#import <Foundation/Foundation.h>

#import "ALMSession.h"
#import "ALMSessionManagerDelegate.h"
#import "ALMCoreModule.h"

extern NSString *const kDefaultLoginPath;

@interface ALMSessionManager : ALMCoreModule

@property (weak, nonatomic) id<ALMSessionManagerDelegate> sessionManagerDelegate;

- (void)setCurrentSession:(ALMSession *)newSession;

+ (instancetype)sessionManagerWithCoreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;

- (RLMResults *)availableSessions;

- (RLMResults *)availableSessionsInRealm:(RLMRealm *)realm;

@end
