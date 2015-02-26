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
#import "ALMResource.h"

#import "ALMCoreModuleDelegate.h"
#import "ALMError.h"


extern NSString *const kControllerSearchParams;

@interface ALMController : AFHTTPSessionManager


#pragma mark - Constructor

- (id)init __attribute__((unavailable));
+ (instancetype)controllerWithURL:(NSURL *)url
                     coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate
                       credential:(ALMCredential *)credential;

+ (instancetype)controllerWithURL:(NSURL *)url
                     coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate
                    configuration:(NSURLSessionConfiguration *)configuration
                       credential:(ALMCredential *)credential;


#pragma mark - Delegate

@property (weak, nonatomic) id<ALMControllerDelegate> controllerDelegate;


#pragma mark - Credential

@property (strong, nonatomic) ALMCredential *credential;
@property (strong, nonatomic) NSString *OAuthPath;
@property (strong, nonatomic) NSString *OAuthScope;


#pragma mark - Options

@property (strong, nonatomic) RLMRealm *realmSearch;


#pragma mark - Auth

- (PMKPromise *)afterAuth;
- (PMKPromise *)AUTH;


#pragma mark - Methods

- (PMKPromise *)SEARCH:(NSString *)query ofType:(Class)resourceClass on:(ALMResource *)parent;
- (PMKPromise *)SEARCH:(NSString *)query ofType:(Class)resourceClass;
- (PMKPromise *)SEARCH:(NSString *)query path:(NSString *)path;

- (PMKPromise *)GETResource:(ALMResource *)resource parameters:(id)parameters;
- (PMKPromise *)GETResource:(Class)resourceClass id:(long long)resourceId parameters:(id)parameters realm:(RLMRealm *)realm;
- (PMKPromise *)GETResource:(Class)resourceClass path:(NSString *)path parameters:(id)parameters realm:(RLMRealm *)realm;
- (PMKPromise *)GETResources:(Class)resourceClass parameters:(id)parameters realm:(RLMRealm *)realm;
- (PMKPromise *)GETResources:(Class)resourceClass path:(NSString *)path parameters:(id)parameters realm:(RLMRealm *)realm;
- (PMKPromise *)GETResources:(Class)resourceClass on:(ALMResource *)parent parameters:(id)parameters;
- (PMKPromise *)GET:(NSString *)urlString parameters:(id)parameters;

- (PMKPromise *)POSTResource:(ALMResource *)resource realm:(RLMRealm *)realm;
- (PMKPromise *)POSTResource:(ALMResource *)resource path:(NSString *)path parameters:(id)parameters realm:(RLMRealm *)realm;
- (PMKPromise *)POST:(NSString *)urlString parameters:(id)parameters;


#pragma mark - Properties

@property (readonly) BOOL isLogingIn;


@end
