//
//  ALMCore.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALMCoreDelegate.h"
#import "ALMUtil.h"
#import "ALMControllerDelegate.h"
#import "ALMController.h"

@interface ALMCore : NSObject <ALMControllerDelegate>

@property (strong, nonatomic) NSString* persistenceStoreName;

#pragma mark - Public constructors

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURL:(NSURL*)baseURL;

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString*)baseURLString;

#pragma mark - Singleton methods

+ (instancetype)sharedInstance;

+ (void)shutDown;

+ (void)setSharedInstance:(ALMCore*)instance;

#pragma mark - Core methods

+ (id)controller:(Class)controller;

+ (id)controller;

- (NSArray*)availableUsers;

#pragma mark - Persistence

- (void)setPersistenceStoreNameToDefault;
- (void)dropDatabaseInMemory;
- (void)dropDatabaseNamed:(NSString*)databaseName;
- (void)dropDatabaseDefault;

@end
