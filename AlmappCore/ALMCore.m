 //
//  ALMCore.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMCore.h"

static NSString *const kMemoryRealmPath = @"temporal.realm";
static NSString *const kDefaultRealmPath = @"realm_v1.realm";
static NSString *const kEncryptedRealmPath = @"encrypted_realm_v1.realm";

static short const kDefaultApiVersion = 1;
static short const kDefaultSemesterDividerMonth = 7;


@interface ALMCore ()

@property (strong, nonatomic) NSMutableDictionary* controllers;

@property (weak, nonatomic) id<ALMCoreDelegate> coreDelegate;
@property (strong, nonatomic) RLMRealm* inMemoryRealm;

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL:(NSURL*)baseURL apiKey:(NSString *)apiKey version:(short)version;

- (void)dropRealm:(RLMRealm*)realm;
- (BOOL)deleteRealmWithPath:(NSString *)realmPath;

@end



@implementation ALMCore

#pragma mark - Private Constructor

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate
               baseURL:(NSURL*)baseURL
                apiKey:(NSString *)apiKey
               version:(short)version {
    
    self = [super init];
    if (self) {
        _coreDelegate = delegate;
        _baseURL = baseURL;
        _apiKey = apiKey;
        _apiVersion = version;
        _controllers = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - Singleton

static ALMCore *_sharedInstance = nil;
static dispatch_once_t once_token;

+ (instancetype)coreWithDelegate:(id<ALMCoreDelegate>)delegate
                         baseURL:(NSURL*)baseURL
                          apiKey:(NSString *)apiKey
                         version:(short)version {
    
    if (baseURL != nil && delegate != nil){
        dispatch_once(&once_token, ^{
            if (_sharedInstance == nil) {
                _sharedInstance = [[self alloc] initWithDelegate:delegate baseURL:baseURL apiKey:apiKey version:version];
            }
        });
        return _sharedInstance;
    } else {
        return nil;
    }
}

+ (instancetype)coreWithDelegate:(id<ALMCoreDelegate>)delegate
                         baseURL:(NSURL *)baseURL
                          apiKey:(NSString *)apiKey {
    
    return [self coreWithDelegate:delegate baseURL:baseURL apiKey:apiKey version:kDefaultApiVersion];
}


+ (BOOL)isAlive {
    return [self sharedInstance] != nil;
}

+ (instancetype)sharedInstance {
    return _sharedInstance;
}

- (void)shutDown {
    BOOL deleteTemporalRealm = [self deleteTemporalDatabase];
    if (!deleteTemporalRealm) {
        NSLog(@"Error, temporal realm was not destroyed");
    }
}

+ (void)setSharedInstance:(ALMCore*)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    _sharedInstance = instance;
}


#pragma mark - Web & Session

- (void)setBaseURL:(NSURL *)baseURL {
    _baseURL = baseURL;
    // TODO: modify managers url
}

- (NSURL *)apiBaseURL {
    if (_apiBaseURL) {
        _apiBaseURL = [self.baseURL URLByAppendingPathComponent:@"/api/v1"];
    }
    return _apiBaseURL;
}

- (NSURL *)chatURL {
    if (_chatURL) {
        _chatURL = [self.baseURL URLByAppendingPathComponent:@"/faye"];
    }
    return _chatURL;
}

- (NSString *)apiKey {
    if (!_apiKey) {
        NSException* myException = [NSException
                                    exceptionWithName:@"ApiKeyNotFound"
                                    reason:@"Api-Key string has not been set on core singleton class"
                                    userInfo:nil];
        @throw myException;
    }
    return _apiKey;
}

- (ALMRequestManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [ALMRequestManager requestManagerWithURL:self.apiBaseURL coreDelegate:self];
    }
    return _requestManager;
}

- (ALMSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [ALMSessionManager sessionManagerWithCoreDelegate:self];
    }
    return _sessionManager;
}

- (ALMChatManager *)chatManager {
    if (!_chatManager) {
        _chatManager = [ALMChatManager chatManagerWithURL:self.chatURL coreDelegate:self];
    }
    return _chatManager;
}

+ (ALMRequestManager *)requestManager {
    return [self isAlive] ? [[self sharedInstance] requestManager] : nil;
}

+ (ALMSessionManager *)sessionManager {
    return [self isAlive] ? [[self sharedInstance] sessionManager] : nil;
}

+ (ALMChatManager *)chatManager {
    return [self isAlive] ? [[self sharedInstance] chatManager] : nil;
}

- (void)setRequestManagerDelegate:(id<ALMRequestManagerDelegate>)delegate {
    self.requestManager.requestManagerDelegate = delegate;
}

- (id<ALMRequestManagerDelegate>)requestManagerDelegate {
    return self.requestManager.requestManagerDelegate;
}

- (void)setSessionManagerDelegate:(id<ALMSessionManagerDelegate>)sessionManagerDelegate {
    self.sessionManager.sessionManagerDelegate = sessionManagerDelegate;
}

- (id<ALMSessionManagerDelegate>)sessionManagerDelegate {
    return self.sessionManager.sessionManagerDelegate;
}

- (void)setCurrentSession:(ALMSession *)session {
    self.sessionManager.currentSession = session;
}

- (ALMSession *)currentSession {
    return self.sessionManager.currentSession;
}

+ (ALMSession *)currentSession {
    return [self sharedInstance] != nil ? [[self sharedInstance] currentSession] : nil;
}


#pragma mark - Academic

+ (short)calculateAcademicYear {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]].year;
}

+ (short)calculateAcademicPeriod {
    NSInteger month = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date]].month;
    return (month < kDefaultSemesterDividerMonth) ? 1 : 2;
}

+ (short)currentAcademicYear {
    return [self sharedInstance] != nil ? [[self sharedInstance] currentAcademicYear] : [self calculateAcademicYear];
}

- (short)currentAcademicYear {
    if([self.coreDelegate respondsToSelector:@selector(coreCurrentAcademicYear)]) {
        return [self.coreDelegate coreCurrentAcademicYear];
    }
    else {
        return [self.class calculateAcademicYear];
    }
}

+ (short)currentAcademicPeriod {
    return [self sharedInstance] != nil ? [[self sharedInstance] currentAcademicPeriod] : [self calculateAcademicPeriod];
}

- (short)currentAcademicPeriod {
    if([self.coreDelegate respondsToSelector:@selector(coreCurrentAcademicPeriod)]) {
        return [self.coreDelegate coreCurrentAcademicPeriod];
    }
    else {
        return [self.class calculateAcademicPeriod];
    }
}


#pragma mark - Persistence

- (void)dropDefaultDatabase {
    [self dropRealm:self.defaultRealm];
}

- (void)dropEncryptedDatabase {
    [self dropRealm:self.encryptedRealm];
}

- (void)dropTemporalDatabase {
    [self dropRealm:self.temporalRealm];
}

- (void)dropDatabaseNamed:(NSString *)name {
    [self dropRealm:[self realmNamed:name]];
}


- (BOOL)deleteDefaultDatabase {
    return [self deleteRealmWithPath:[self defaultRealmPath]];
}

- (BOOL)deleteEncryptedDatabase {
    return [self deleteDatabaseNamed:kEncryptedRealmPath];
}

- (BOOL)deleteTemporalDatabase {
    return [self deleteDatabaseNamed:kMemoryRealmPath];
}

- (BOOL)deleteDatabaseNamed:(NSString *)name {
    NSString *path = [self.class writeablePathForFile:name];
    return [self deleteRealmWithPath:path];
}

- (void)dropRealm:(RLMRealm*)realm {
    NSLog(@"Drop database at: %@", realm.path);
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

- (BOOL)deleteRealmWithPath:(NSString *)realmPath {
    NSLog(@"Deleting Realm database at: %@", realmPath);
    return [[NSFileManager defaultManager] removeItemAtPath:realmPath error:nil];
}



- (NSString *)defaultRealmPath {
    return [RLMRealm defaultRealmPath];
}

+ (NSString *)defaultRealmPath {
    return [RLMRealm defaultRealmPath];
}

+ (RLMRealm *)defaultRealm {
    return [RLMRealm defaultRealm];
}

- (RLMRealm *)defaultRealm {
    return [RLMRealm defaultRealm];
}

+ (RLMRealm *)realmNamed:(NSString *)name {
    NSString *path = [ALMUtil writeablePathForFile:name];
    return [RLMRealm realmWithPath:path];
}

- (RLMRealm *)realmNamed:(NSString *)name {
    return [self.class realmNamed:name];
}

+ (RLMRealm *)temporalRealm {
    return [self realmNamed:kMemoryRealmPath];
    //return [self isAlive] ? [[self sharedInstance] temporalRealm] : nil;
}

- (RLMRealm *)temporalRealm {
    return [self realmNamed:kMemoryRealmPath];
    /*
    if (_inMemoryRealm == nil){
        _inMemoryRealm = [RLMRealm inMemoryRealmWithIdentifier:kMemoryRealmPath];
        return _inMemoryRealm;
    }
    return [RLMRealm inMemoryRealmWithIdentifier:kMemoryRealmPath];
     */
}

+ (RLMRealm *)encryptedRealm {
    return [self isAlive] ? [[self sharedInstance] encryptedRealm] : nil;
}

- (RLMRealm *)encryptedRealm {
    
    // TODO, INCOMPLETE
    
    //NSString *realmPath = [self.class writeablePathForFile:kEncryptedRealmPath];
    //return [RLMRealm encryptedRealmWithPath:realmPath key:nil readOnly:NO error:nil];
    
    return self.defaultRealm;
}


#pragma mark - ALMCoreModuleDelegate implementation

- (ALMSessionManager *)moduleSessionManagerFor:(Class)module {
    return [self sessionManager];
}

- (ALMSession *)moduleCurrentSessionFor:(Class)module {
    return [self currentSession];
}

- (NSString *)moduleApiKeyFor:(Class)module {
    return [self apiKey];
}

- (RLMRealm *)module:(Class)module realmNamed:(NSString *)name {
    return [self realmNamed:name];
}

- (RLMRealm *)moduleDefaultRealmFor:(Class)module {
    return [self defaultRealm];
}

- (RLMRealm *)moduleTemporalRealmFor:(Class)module {
    return [self temporalRealm];
}

- (RLMRealm *)moduleEncryptedRealmFor:(Class)module {
    return [self encryptedRealm];
}

@end
