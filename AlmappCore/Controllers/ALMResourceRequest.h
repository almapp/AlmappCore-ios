//
//  ALMResourceRequest.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALMSession.h"
#import "ALMRequestDelegate.h"

extern BOOL const kRequestForceLogin;

@interface ALMResourceRequest : NSObject

@property (weak, nonatomic) id<ALMRequestDelegate> requestDelegate;

@property (strong, nonatomic) NSString *realmPath;
@property (readonly) RLMRealm *realm;
- (void)setRealm:(RLMRealm *)realm;

@property (weak, nonatomic) ALMSession *session;

@property (nonatomic, strong) dispatch_queue_t dispatchQueue;

@property (strong, nonatomic) NSString *customPath;
@property (copy, readonly) NSString *intuitedPath;
@property (readonly) NSString *path;

@property (strong, nonatomic) NSArray *resourcesIDs;
- (void)setResourcesIDsWith:(RLMResults *)resourcesIDs;

@property (assign, nonatomic) long long resourceID;
@property (strong, nonatomic) Class resourceClass;
@property (strong, nonatomic) id parameters;

@property (assign, nonatomic) BOOL shouldLog;
@property (assign, nonatomic, getter=isRequestingACollection) BOOL requestCollection;

+ (instancetype)request:(void(^)(ALMResourceRequest *r))builderBlock delegate:(id<ALMRequestDelegate>)delegate;

+ (NSString *)intuitedPathFor:(Class)resourceClass;
+ (NSString *)intuitedPathFor:(Class)resourceClass withID:(long long)resourceID;


- (void)publishError:(NSError *)error task:(NSURLSessionDataTask *)task;

- (void)sortOrFilterResources:(RLMResults *)resources;

- (void)publishLoaded:(id)object;

// - (void)publishLoadedResource:(ALMResource *)resource;
// - (void)publishLoadedResources:(RLMResults *)resources;

- (void)publishFetched:(id)object task:(NSURLSessionDataTask *)task;

// - (void)publishFetchedResource:(ALMResource *)resource task:(NSURLSessionDataTask *)task;
// - (void)publishFetchedResources:(RLMResults *)resources task:(NSURLSessionDataTask *)task;

- (BOOL)commitData:(id)data;

// - (BOOL)commitMultiple:(Class)resourceClass data:(NSArray *)data inRealm:(RLMRealm *)realm;
// - (BOOL)commitSingle:(Class)resourceClass data:(NSDictionary *)data inRealm:(RLMRealm *)realm;

@end
