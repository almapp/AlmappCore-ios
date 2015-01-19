//
//  ALMCore.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMCore.h"

static NSString *const MEMORY_REALM_PATH = @"TemporalRealm";
static short const kDefaultSemesterDividerMonth = 7;

@interface ALMCore ()

@property (strong, nonatomic) NSMutableDictionary* controllers;

@property (strong, nonatomic) id<ALMCoreDelegate> coreDelegate;
@property (strong, nonatomic) NSURL* baseURL;
@property (strong, nonatomic) RLMRealm* inMemoryRealm;

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL: (NSURL*)baseURL;

- (void)dropRealm:(RLMRealm*)realm;
- (void)deleteRealm:(RLMRealm*)realm;

@end

@implementation ALMCore

#pragma mark - Private Constructor

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL: (NSURL*)baseURL {
    self = [super init];
    if (self) {
        _coreDelegate = delegate;
        _baseURL = baseURL;
        _controllers = [NSMutableDictionary dictionary];
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

+ (id)controller {
    return [ALMCore controller:[ALMController class]];
}

+ (id)controller:(Class)controller {
    if ([ALMCore sharedInstance] != nil) {
        return [[ALMCore sharedInstance] controller:controller];
    }
    else {
        return nil;
    }
}

- (id)controller:(Class)controllerClass {
    if([controllerClass isSubclassOfClass:[ALMController class]]) {
        ALMController* controller = [_controllers objectForKey:controllerClass];
        if(controller != nil) {
            return controller;
        }
        else {
            controller = [controllerClass performSelector:@selector(controllerWithDelegate:) withObject:self];
            [_controllers setObject:controller forKey:(id <NSCopying>)controllerClass];
            return controller;
        }
    }
    else {
        return nil;
    }
}

- (id)controller {
    return [self controller:[ALMController class]];
}

- (NSArray*)availableUsers {
    return nil;
}

+ (short)defaultAcademicYear {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]].year;
}

+ (short)currentAcademicYear {
    return [ALMCore sharedInstance] != nil ? [[ALMCore sharedInstance] currentAcademicYear] : [self defaultAcademicYear];
}

- (short)currentAcademicYear {
    if([self.coreDelegate respondsToSelector:@selector(currentAcademicYear)]) {
        return [self.coreDelegate currentAcademicYear];
    }
    else {
        return [self.class defaultAcademicYear];
    }
}

+ (short)defaultAcademicPeriod {
    NSInteger month = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date]].month;
    return (month < kDefaultSemesterDividerMonth) ? 1 : 2;
}

+ (short)currentAcademicPeriod {
    return [ALMCore sharedInstance] != nil ? [[ALMCore sharedInstance] currentAcademicPeriod] : [self defaultAcademicPeriod];
}

- (short)currentAcademicPeriod {
    if([self.coreDelegate respondsToSelector:@selector(currentAcademicPeriod)]) {
        return [self.coreDelegate currentAcademicPeriod];
    }
    else {
        return [self.class defaultAcademicPeriod];
    }
}


#pragma mark - Persistence

- (void)dropDatabaseDefault {
    [self dropRealm:[self requestRealm]];
}

- (void)dropDatabaseInMemory {
    [self dropRealm:[self requestTemporalRealm]];
}

- (void)deleteDatabaseDefault {
    [self deleteRealm:[self requestRealm]];
}

- (void)deleteDatabaseInMemory {
    [self deleteRealm:[self requestTemporalRealm]];
}

- (void)dropRealm:(RLMRealm*)realm {
    NSLog(@"%@", realm.path);
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

- (void)deleteRealm:(RLMRealm*)realm {
    [[NSFileManager defaultManager] removeItemAtPath:realm.path error:nil];
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
    return [RLMRealm defaultRealm];
}

- (RLMRealm *)requestTemporalRealm {
    if (_inMemoryRealm == nil){
        _inMemoryRealm = [RLMRealm inMemoryRealmWithIdentifier:MEMORY_REALM_PATH];
        return _inMemoryRealm;
    }
    return [RLMRealm inMemoryRealmWithIdentifier:MEMORY_REALM_PATH];
}

@end
