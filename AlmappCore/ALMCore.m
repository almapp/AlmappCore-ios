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

static short const kDefaultSemesterDividerMonth = 7;

@interface ALMCore ()

@property (strong, nonatomic) NSMutableDictionary* controllers;

@property (weak, nonatomic) id<ALMCoreDelegate> coreDelegate;
@property (strong, nonatomic) NSURL* baseURL;
@property (strong, nonatomic) RLMRealm* inMemoryRealm;

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL: (NSURL*)baseURL apiKey:(NSString *)apiKey;

- (void)dropRealm:(RLMRealm*)realm;
- (void)deleteRealm:(RLMRealm*)realm;

@end

@implementation ALMCore

#pragma mark - Private Constructor

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL: (NSURL*)baseURL apiKey:(NSString *)apiKey {
    self = [super init];
    if (self) {
        _coreDelegate = delegate;
        _baseURL = baseURL;
        _controllers = [NSMutableDictionary dictionary];
        _apiKey = apiKey;
    }
    return self;
}

#pragma mark - Singleton

static ALMCore *_sharedInstance = nil;
static dispatch_once_t once_token;

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURL:(NSURL*)baseURL apiKey:(NSString *)apiKey {
    if (baseURL != nil && delegate != nil){
        dispatch_once(&once_token, ^{
            if (_sharedInstance == nil) {
                _sharedInstance = [[self alloc] initWithDelegate:delegate baseURL:baseURL apiKey:apiKey];
            }
        });
        return _sharedInstance;
    } else {
        return nil;
    }
}

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString *)baseURLString apiKey:(NSString *)apiKey {
    return [self initInstanceWithDelegate:delegate baseURL:[NSURL URLWithString:baseURLString] apiKey:apiKey];
}

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString *)baseURLString {
    return [self initInstanceWithDelegate:delegate baseURLString:baseURLString apiKey:nil];
}

+ (BOOL)isAlive {
    return [self sharedInstance] != nil;
}

+ (instancetype)sharedInstance {
    return _sharedInstance;
}

+ (void)shutDown {
}

+ (void)setSharedInstance:(ALMCore*)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    _sharedInstance = instance;
}


#pragma mark - Web & Session

- (NSString *)baseURLString {
    return [_baseURL absoluteString];
}

- (NSURL *)baseURL {
    return _baseURL;
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
        _requestManager = [[ALMRequestManager alloc] initWithBaseURL:_baseURL delegate:self];
    }
    return _requestManager;
}

- (ALMSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[ALMSessionManager alloc] init];
    }
    return _sessionManager;
}

+ (ALMRequestManager *)requestManager {
    return [self isAlive] ? [[self sharedInstance] requestManager] : nil;
}

+ (ALMSessionManager *)sessionManager {
    return [self isAlive] ? [[self sharedInstance] sessionManager] : nil;
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


#pragma mark - Controller


+ (id)controller {
    return nil;
}

+ (id)controller:(Class)controllerClass {
    return ([self sharedInstance] != nil) ? [[self sharedInstance] controller:controllerClass] : nil;
}

- (id)controller:(Class)controllerClass {
    return nil;
}

- (id)controller {
    return nil;
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
    if([self.coreDelegate respondsToSelector:@selector(currentAcademicYear)]) {
        return [self.coreDelegate currentAcademicYear];
    }
    else {
        return [self.class calculateAcademicYear];
    }
}

+ (short)currentAcademicPeriod {
    return [self sharedInstance] != nil ? [[self sharedInstance] currentAcademicPeriod] : [self calculateAcademicPeriod];
}

- (short)currentAcademicPeriod {
    if([self.coreDelegate respondsToSelector:@selector(currentAcademicPeriod)]) {
        return [self.coreDelegate currentAcademicPeriod];
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

- (void)deleteDefaultDatabase {
    [self deleteRealm:self.defaultRealm];
}

- (void)deleteEncryptedDatabase {
    [self deleteRealm:self.encryptedRealm];
}

- (void)deleteTemporalDatabase {
    [self deleteRealm:self.temporalRealm];
}

- (void)deleteDatabaseNamed:(NSString *)name {
    [self deleteRealm:[self realmNamed:name]];
}

- (void)dropRealm:(RLMRealm*)realm {
    NSLog(@"Drop database at: %@", realm.path);
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

- (void)deleteRealm:(RLMRealm*)realm {
    NSLog(@"Delete database at: %@", realm.path);
    [[NSFileManager defaultManager] removeItemAtPath:realm.path error:nil];
}

+ (RLMRealm *)defaultRealm {
    return [self isAlive] ? [[self sharedInstance] defaultRealm] : nil;
}

- (RLMRealm *)defaultRealm {
    return [RLMRealm defaultRealm];
}

+ (RLMRealm *)realmNamed:(NSString *)name {
    return [self isAlive] ? [[self sharedInstance] realmNamed:name] : nil;
}

- (RLMRealm *)realmNamed:(NSString *)name {
    return nil;
}

+ (RLMRealm *)temporalRealm {
    return [self isAlive] ? [[self sharedInstance] temporalRealm] : nil;
}

- (RLMRealm *)temporalRealm {
    if (_inMemoryRealm == nil){
        _inMemoryRealm = [RLMRealm inMemoryRealmWithIdentifier:kMemoryRealmPath];
        return _inMemoryRealm;
    }
    return [RLMRealm inMemoryRealmWithIdentifier:kMemoryRealmPath];
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


+ (NSString *)writeablePathForFile:(NSString*)fileName
{
#if TARGET_OS_IPHONE
    // On iOS the Documents directory isn't user-visible, so put files there
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
#else
    // On OS X it is, so put files in Application Support. If we aren't running
    // in a sandbox, put it in a subdirectory based on the bundle identifier
    // to avoid accidentally sharing files between applications
    NSString *path = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
    if (![[NSProcessInfo processInfo] environment][@"APP_SANDBOX_CONTAINER_ID"]) {
        NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
        if ([identifier length] == 0) {
            identifier = [[[NSBundle mainBundle] executablePath] lastPathComponent];
        }
        path = [path stringByAppendingPathComponent:identifier];
        
        // create directory
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
#endif
    return [path stringByAppendingPathComponent:fileName];
}

@end
