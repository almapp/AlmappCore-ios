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
#import <PromiseKit/Promise+When.h>
#import <Realm+JSON/RLMObject+JSON.h>

#import "ALMControllerDelegate.h"

#import "ALMNestedRequestDelegate.h"
#import "ALMCoreModuleDelegate.h"
#import "ALMError.h"

#import "ALMResourceRequest.h"
#import "ALMResourceRequestBlock.h"
#import "ALMResourceResponse.h"
#import "ALMResourceResponseBlock.h"

extern NSString *const kControllerSearchParams;

@interface ALMController : AFHTTPSessionManager


#pragma mark - Constructor

- (id)init __attribute__((unavailable));
+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;
+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate configuration:(NSURLSessionConfiguration *)configuration;


#pragma mark - Delegate

@property (weak, nonatomic) id<ALMControllerDelegate> controllerDelegate;


#pragma mark - Auth

- (PMKPromise *)authPromiseWithCredential:(ALMCredential *)credential;

- (PMKPromise *)AUTH:(ALMCredential *)credential;
- (PMKPromise *)AUTH:(ALMCredential *)credential oauthUrl:(NSString *)oauthUrl scope:(NSString *)scope;


#pragma mark - Methods

- (PMKPromise *)LOAD:(ALMResourceRequest *)request;
- (PMKPromise *)FETCH:(ALMResourceRequest *)request;

- (PMKPromise *)SEARCH:(ALMResourceRequest *)request params:(NSDictionary *)params;
- (PMKPromise *)SEARCH:(ALMResourceRequest *)request query:(NSString *)query;


- (PMKPromise *)GET:(ALMResourceRequest *)request;
- (PMKPromise *)POST:(ALMResourceResponse *)response;
- (PMKPromise *)DELETE:(ALMResourceRequest *)request;
- (PMKPromise *)PUT:(ALMResourceRequest *)request;


#pragma mark - Properties

@property (assign, nonatomic) BOOL isLogingIn;


#pragma mark - Realm

- (RLMRealm*)temporalRealm;
- (RLMRealm*)defaultRealm;
- (RLMRealm *)encryptedRealm;

@end
