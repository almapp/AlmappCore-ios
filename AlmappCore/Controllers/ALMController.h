//
//  ALMController.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFNetworking+PromiseKit.h"
#import <PromiseKit.h>


#import <Realm+JSON/RLMObject+JSON.h>

#import "ALMNestedRequestDelegate.h"
#import "ALMCoreModuleDelegate.h"
#import "ALMError.h"

#import "ALMResourceRequest.h"
#import "ALMNestedResourceRequest.h"

@interface ALMController : AFHTTPSessionManager

#pragma mark - Delegates
 
@property (assign, nonatomic) BOOL isLogingIn;

- (id)init __attribute__((unavailable));
+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;
+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate configuration:(NSURLSessionConfiguration *)configuration;

- (PMKPromise *)LOAD:(ALMResourceRequest *)request;
- (PMKPromise *)FETCH:(ALMResourceRequest *)request;

- (PMKPromise *)GET:(ALMResourceRequest *)request;
- (PMKPromise *)POST:(ALMResourceRequest *)request;
- (PMKPromise *)DELETE:(ALMResourceRequest *)request;
- (PMKPromise *)PUT:(ALMResourceRequest *)request;

- (void)setupWithEmail:(NSString *)email password:(NSString *)password;
- (void)setupWithEmail:(NSString *)email password:(NSString *)password oauthUrl:(NSString *)oauthUrl scope:(NSString *)scope;

- (RLMRealm*)temporalRealm;
- (RLMRealm*)defaultRealm;
- (RLMRealm *)encryptedRealm;

@end
