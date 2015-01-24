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

#import "ALMRequest.h"
#import "ALMSingleRequest.h"
#import "ALMCollectionRequest.h"
#import "ALMNestedCollectionRequest.h"

@interface NSURLSessionDataTask (ALMRequest)

@property (readonly) NSHTTPURLResponse *httpResponse;

@end

@interface ALMRequestManager : AFHTTPSessionManager

#pragma mark - Delegates

@property (weak, nonatomic) id<ALMRequestManagerDelegate> requestManagerDelegate;

#pragma mark - Constructor

- (id)init __attribute__((unavailable));
- (id)initWithBaseURLString:(NSString *)urlString delegate:(id<ALMRequestManagerDelegate>)delegate;
- (id)initWithBaseURL:(NSURL *)url delegate:(id<ALMRequestManagerDelegate>)delegate;
- (id)initWithBaseURLString:(NSString *)urlString sessionConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<ALMRequestManagerDelegate>)delegate;
- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<ALMRequestManagerDelegate>)delegate;

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
