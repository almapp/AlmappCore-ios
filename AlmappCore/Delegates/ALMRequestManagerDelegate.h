//
//  ALMRequestManagerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#import "ALMSession.h"
#import "ALMSessionManager.h"

@protocol ALMRequestManagerDelegate <NSObject>

@optional

- (ALMSession *)parseResponseHeaders:(NSDictionary *)headers data:(id)data to:(ALMSession *)session;

@required

- (ALMSessionManager *)sessionManager;
- (NSString *)apiKey;

- (RLMRealm *)realmNamed:(NSString *)name;
- (RLMRealm *)defaultRealm;
- (RLMRealm *)temporalRealm;
- (RLMRealm *)encryptedRealm;

@end
