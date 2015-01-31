//
//  ALMSessionManagerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMSessionManager, ALMSession;

@protocol ALMSessionManagerDelegate <NSObject>

@optional

- (ALMSession *)sessionManagerGetCurrentSession;
- (BOOL)sessionManager:(ALMSessionManager *)manager shouldChangeToSession:(ALMSession *)session;
- (void)sessionManager:(ALMSessionManager *)manager didChangeSessionTo:(ALMSession *)session;
- (RLMRealm *)sessionManagerSessionsStoreRealm:(ALMSessionManager *)manager;

@end