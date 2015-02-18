//
//  ALMCore.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

#import "ALMCoreDelegate.h"
#import "ALMCoreModuleDelegate.h"

#import "ALMSessionManager.h"
#import "ALMController.h"
#import "ALMChatManager.h"

#import "ALMUtil.h"
#import "ALMApiKey.h"

extern NSString *const kFrameworkIdentifier;

@interface ALMCore : NSObject <ALMCoreModuleDelegate>

#pragma mark - Public constructors

+ (instancetype)coreWithDelegate:(id<ALMCoreDelegate>)delegate
                         baseURL:(NSURL *)baseURL
                         apiVersion:(short)version
                          apiKey:(ALMApiKey *)apiKey
                    organization:(NSString *)organization;

+ (instancetype)coreWithDelegate:(id<ALMCoreDelegate>)delegate
                         baseURL:(NSURL *)baseURL
                          apiKey:(ALMApiKey *)apiKey
                    organization:(NSString *)organization;


#pragma mark - Singleton methods

+ (instancetype)sharedInstance;

+ (BOOL)isAlive;

- (void)shutDown;

+ (void)setSharedInstance:(ALMCore*)instance;


#pragma mark - Web & Session

@property (assign, nonatomic) short apiVersion;
@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) NSURL *apiBaseURL;
@property (strong, nonatomic) NSURL *chatURL;
@property (strong, nonatomic) NSString *organizationIdentifier;

@property (strong, nonatomic) ALMApiKey *apiKey;
@property (assign, nonatomic) BOOL shouldSyncToCloud;

@property (strong, nonatomic) ALMSessionManager *sessionManager;
@property (strong, nonatomic) ALMChatManager *chatManager;

- (ALMController *)controller;
+ (ALMController *)controller;

- (ALMController *)controllerWithCredential:(ALMCredential *)credential;
+ (ALMController *)controllerWithCredential:(ALMCredential *)credential;

- (void)deallocControllerWithCredential:(ALMCredential *)credential;
+ (void)deallocControllerWithCredential:(ALMCredential *)credential;

+ (ALMSessionManager *)sessionManager;
+ (ALMChatManager *)chatManager;

- (id<ALMSessionManagerDelegate>)sessionManagerDelegate;
- (void)setSessionManagerDelegate:(id<ALMSessionManagerDelegate>)sessionManagerDelegate;

- (ALMSession *)currentSession;
+ (ALMSession *)currentSession;


#pragma mark - Keychain

- (UICKeyChainStore *)keyStore;
+ (UICKeyChainStore *)keyStore;


#pragma mark - Academic

+ (short)currentAcademicYear;
- (short)currentAcademicYear;

+ (short)currentAcademicPeriod;
- (short)currentAcademicPeriod;


#pragma mark - Persistence

+ (RLMRealm *)realmNamed:(NSString *)name;
- (RLMRealm *)realmNamed:(NSString *)name;

+ (RLMRealm *)defaultRealm;
- (RLMRealm *)defaultRealm;

+ (RLMRealm *)temporalRealm;
- (RLMRealm *)temporalRealm;

+ (RLMRealm *)encryptedRealm;
- (RLMRealm *)encryptedRealm;

- (void)dropDatabaseNamed:(NSString *)name;
- (void)dropTemporalDatabase;
- (void)dropDefaultDatabase;
- (void)dropEncryptedDatabase;

- (BOOL)deleteDatabaseNamed:(NSString *)name;
- (BOOL)deleteTemporalDatabase;
- (BOOL)deleteDefaultDatabase;
- (BOOL)deleteEncryptedDatabase;

@end
