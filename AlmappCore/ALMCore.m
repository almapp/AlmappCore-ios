//
//  ALMCore.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMCore.h"

static NSString *const MEMORY_REALM_PATH = @"TemporalRealm";
static NSString *const DEFAULT_PERSISTENCE_STORE = @"DefaultPersistenceStore";

@interface ALMCore ()

@property (strong, nonatomic) id<ALMCoreDelegate> coreDelegate;
@property (strong, nonatomic) NSURL* baseURL;
@property (strong, nonatomic) RLMRealm* inMemoryRealm;

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL: (NSURL*)baseURL;

@end

@implementation ALMCore

#pragma mark - Private Constructor

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL: (NSURL*)baseURL {
    self = [super init];
    if (self) {
        _coreDelegate = delegate;
        _baseURL = baseURL;
        [self setPersistenceStoreNameToDefault];
    }
    return self;
}

#pragma mark - Singleton

static ALMCore *_sharedInstance = nil;
static dispatch_once_t once_token;

+ (ALMCore*)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURL:(NSURL*)baseURL {
    if (baseURL != nil && delegate != nil){
        dispatch_once(&once_token, ^{
            if (_sharedInstance == nil) {
                _sharedInstance = [[ALMCore alloc] initWithDelegate:delegate baseURL:baseURL];
            }
        });
        return _sharedInstance;
    } else {
        return nil;
    }
}

+ (ALMCore*)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString*)baseURLString {
    if(true) {
        return [ALMCore initInstanceWithDelegate:delegate baseURL:[NSURL URLWithString:baseURLString]];
    } else {
        return nil;
    }
}

+ (ALMCore*)sharedInstance {
    return _sharedInstance;
}

+ (void)shutDown {
}

+ (void)setSharedInstance:(ALMCore*)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    _sharedInstance = instance;
}

#pragma mark - Core Methods

- (NSArray*)availableUsers {
    return nil;
}

- (void)setPersistenceStoreNameToDefault {
    _persistenceStoreName = DEFAULT_PERSISTENCE_STORE;
}

#pragma mark - Exposed attributes



#pragma mark - Controller Delegate Implementation

- (NSString *)baseURL {
    return [_baseURL absoluteString];
}

- (AFHTTPRequestOperationManager *)requestManager {
    return [AFHTTPRequestOperationManager manager];
}

- (RLMRealm *)requestRealm {
    return [RLMRealm realmWithPath:_persistenceStoreName];
}

- (RLMRealm *)requestTemporalRealm {
    if (_inMemoryRealm == nil){
        _inMemoryRealm = [RLMRealm inMemoryRealmWithIdentifier:MEMORY_REALM_PATH];
        return _inMemoryRealm;
    }
    return [RLMRealm inMemoryRealmWithIdentifier:MEMORY_REALM_PATH];
}

@end
