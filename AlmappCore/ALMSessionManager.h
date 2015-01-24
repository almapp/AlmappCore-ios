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

extern NSString *const kDefaultLoginPath;

@interface ALMSessionManager : NSObject <ALMSessionManagerDelegate>

@property (weak, nonatomic) id<ALMSessionManagerDelegate> sessionManagerDelegate;

@property (strong, nonatomic) ALMSession *currentSession;

- (instancetype)initWithDelegate:(id<ALMSessionManagerDelegate>)delegate;

- (RLMResults *)availableSessions;

- (RLMResults *)availableSessionsInRealm:(RLMRealm *)realm;

- (NSString *)loginPostPath:(ALMSession *)session;


@end
