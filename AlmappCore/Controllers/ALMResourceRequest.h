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

@interface ALMResourceRequest : NSObject <NSCopying>

#pragma mark - Constructor

+ (instancetype)request:(void(^)(ALMResourceRequest *r))builderBlock delegate:(id<ALMRequestDelegate>)delegate;


#pragma mark - Delegate

@property (weak, nonatomic) id<ALMRequestDelegate> requestDelegate;

- (void)publishError:(NSError *)error task:(NSURLSessionDataTask *)task;

- (RLMResults *)sortOrFilterResources:(RLMResults *)resources;

- (void)publishLoaded:(id)object;

- (void)publishFetched:(id)object task:(NSURLSessionDataTask *)task;

- (void)publishFetchedResources:(RLMResults *)resources withParent:(id)parent;

- (BOOL)commitData:(id)data;


#pragma mark - Realm

@property (strong, nonatomic) NSString *realmPath;
- (RLMRealm *)realm;
- (void)setRealm:(RLMRealm *)realm;


#pragma mark - Paths

@property (strong, nonatomic) NSString *customPath;
@property (copy, readonly) NSString *intuitedPath;
@property (readonly) NSString *path;

+ (NSString *)intuitedPathFor:(Class)resourceClass;
+ (NSString *)intuitedPathFor:(Class)resourceClass withID:(long long)resourceID;


#pragma mark - Resources

@property (assign, nonatomic) long long resourceID;
@property (strong, nonatomic) Class resourceClass;
@property (strong, nonatomic) NSArray *resourcesIDs;
- (void)setResourcesIDsWith:(RLMResults *)resourcesIDs;


#pragma mark - Other

@property (strong, nonatomic) ALMCredential *credential;
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;

@property (strong, nonatomic) id parameters;
@property (assign, nonatomic) BOOL shouldLog;
@property (assign, nonatomic, getter=isRequestingACollection) BOOL requestCollection;

@end
