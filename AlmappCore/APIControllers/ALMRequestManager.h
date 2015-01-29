//
//  ALMRequestManager.h
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <AFNetworking/AFNetworking.h>
#import <Realm+JSON/RLMObject+JSON.h>

#import "ALMRequestManagerDelegate.h"
#import "ALMCoreModuleDelegate.h"

#import "ALMRequest.h"
#import "ALMSingleRequest.h"
#import "ALMCollectionRequest.h"
#import "ALMNestedCollectionRequest.h"

@interface ALMRequestManager : AFHTTPSessionManager

#pragma mark - Delegates

@property (weak, nonatomic) id<ALMRequestManagerDelegate> requestManagerDelegate;

#pragma mark - Constructor

- (id)init __attribute__((unavailable));
+ (instancetype)requestManagerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;
+ (instancetype)requestManagerWithURL:(NSURL *)url configuration:(NSURLSessionConfiguration *)configuration coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;


#pragma mark - Managers

- (RLMRealm *)temporalRealm;
- (RLMRealm *)defaultRealm;
- (RLMRealm *)encryptedRealm;


#pragma mark - Request Methods

- (NSURLSessionDataTask *)GET:(ALMRequest *)request;

- (NSURLSessionDataTask *)loginWith:(ALMSession *)session
                          onSuccess:(void (^)(NSURLSessionDataTask *task, ALMSession *session))onSuccess
                             onFail:(void (^)(NSURLSessionDataTask *task, NSError *error))onFail;
    
@end
