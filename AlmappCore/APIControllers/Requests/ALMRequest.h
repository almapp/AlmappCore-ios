//
//  ALMRequest.h
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALMSession.h"

extern long long const kDefaultRequestID;

@class ALMRequestManager;

@interface ALMRequest : NSObject

@property (strong, nonatomic) NSString *realmPath;
@property (readonly) RLMRealm *realm;
- (void)setRealm:(RLMRealm *)realm;
@property (strong, nonatomic) ALMSession *session;

@property (strong, nonatomic) NSString *customPath;
@property (copy, readonly) NSString *intuitedPath;
@property (copy, readonly) NSString *path;
+ (NSString *)intuitedPathFor:(Class)resourceClass;

@property (strong, nonatomic) Class resourceClass;
@property (strong, nonatomic) id parameters;
@property (assign, nonatomic) BOOL shouldLog;

@property (copy, nonatomic) void (^onError)(NSURLSessionDataTask *task, NSError* error);

@property (copy, nonatomic) BOOL (^tokenValidationOperation)(ALMCredential *credential);
@property (readonly, copy, nonatomic) BOOL (^defaultTokenValidationOperation)(ALMCredential *credential);

@property (copy, nonatomic) NSDictionary* (^configureHttpRequestHeaders)(ALMSession *session, NSString *apiKey);
+ (NSDictionary *(^)(ALMSession *, NSString *))defaultHttpHeaders;

@property (strong, nonatomic) NSURLSessionDataTask* (^customRequestTask)(ALMRequestManager *manager, ALMRequest *request);

+ (NSString *)defaultRealmPath;
- (BOOL)needsAuthentication;
- (BOOL)validateRequest;

- (id)execCommit:(id)data;
- (void)execOnLoad;
- (void)execOnFinishWithTask:(NSURLSessionDataTask *)task;
- (id)execFetch:(NSURLSessionDataTask *)task fetchedData:(id)result;

@end
