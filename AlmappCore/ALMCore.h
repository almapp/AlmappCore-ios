//
//  ALMCore.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALMCoreDelegate.h"
#import "ALMRequestManager.h"

#import "ALMUtil.h"

@interface ALMCore : NSObject <ALMRequestManagerDelegate>

#pragma mark - Public constructors

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURL:(NSURL *)baseURL apiKey:(NSString *)apiKey;

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString *)baseURLString apiKey:(NSString *)apiKey;

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString *)baseURLString;


#pragma mark - Singleton methods

+ (instancetype)sharedInstance;

+ (BOOL)isAlive;

- (void)shutDown;

+ (void)setSharedInstance:(ALMCore*)instance;


#pragma mark - Web & Session

- (NSURL *)baseURL;
- (NSString *)baseURLString;

@property (strong, nonatomic) NSString *apiKey;

@property (strong, nonatomic) ALMRequestManager *requestManager;
@property (strong, nonatomic) ALMSessionManager *sessionManager;

+ (ALMRequestManager *)requestManager;
+ (ALMSessionManager *)sessionManager;

- (id<ALMRequestManagerDelegate>) requestManagerDelegate;
- (void) setRequestManagerDelegate:(id<ALMRequestManagerDelegate>)delegate;

- (id<ALMSessionManagerDelegate>)sessionManagerDelegate;
- (void)setSessionManagerDelegate:(id<ALMSessionManagerDelegate>)sessionManagerDelegate;

- (ALMSession *)currentSession;
+ (ALMSession *)currentSession;


#pragma mark - Controllers


+ (id)controller:(Class)controllerClass;

+ (id)controller;

- (id)controller:(Class)controllerClass;

- (id)controller;



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
