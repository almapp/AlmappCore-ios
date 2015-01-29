//
//  ALMCoreModuleDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMSession, ALMSessionManager, RLMRealm;
@class ALMCoreModule;

@protocol ALMCoreModuleDelegate <NSObject>

@required

- (ALMSessionManager *)moduleSessionManagerFor:(Class)module;
- (ALMSession *)moduleCurrentSessionFor:(Class)module;
- (NSString *)moduleApiKeyFor:(Class)module;

- (RLMRealm *)module:(Class)module realmNamed:(NSString *)name;
- (RLMRealm *)moduleDefaultRealmFor:(Class)module;
- (RLMRealm *)moduleTemporalRealmFor:(Class)module;
- (RLMRealm *)moduleEncryptedRealmFor:(Class)module;

@end