//
//  AlmappCore.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "AlmappCore.h"

@interface AlmappCore ()

@property (strong, nonatomic) id<ALMCoreDelegate> coreDelegate;
@property (strong, nonatomic) NSURL* baseURL;

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL: (NSURL*)baseURL;
- (void)startActiveRecord;

@end


@implementation AlmappCore

#pragma mark - Private Constructor

- (id)initWithDelegate:(id<ALMCoreDelegate>)delegate baseURL: (NSURL*)baseURL {
    self = [super init];
    if (self) {
        _coreDelegate = delegate;
        _baseURL = baseURL;
    }
    return self;
}

#pragma mark - Singleton

static AlmappCore *_sharedInstance = nil;
static dispatch_once_t once_token;

+ (AlmappCore*)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURL:(NSURL*)baseURL {
    if (baseURL != nil && delegate != nil){
        dispatch_once(&once_token, ^{
            if (_sharedInstance == nil) {
                _sharedInstance = [[AlmappCore alloc] initWithDelegate:delegate baseURL:baseURL];
                [_sharedInstance startActiveRecord];
            }
        });
        return _sharedInstance;
    } else {
        return nil;
    }
}

+ (AlmappCore*)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString*)baseURLString {
    if(true) {
        return [AlmappCore initInstanceWithDelegate:delegate baseURL:[NSURL URLWithString:baseURLString]];
    } else {
        return nil;
    }
}

+ (AlmappCore*)sharedInstance {
    return _sharedInstance;
}

+ (void)shutDown {
}

+ (void)setSharedInstance:(AlmappCore*)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    _sharedInstance = instance;
}

#pragma mark - Core Methods

- (void)startActiveRecord {
}

- (NSArray*)availableUsers {
    return nil;
}

#pragma mark - Exposed attributes



#pragma mark - Controller Delegate Implementation



@end
