//
//  ALMRequestDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMSession, ALMSessionManager, RLMRealm, RLMResults, ALMResource;
@class ALMController, ALMResourceRequest;

@protocol ALMRequestDelegate <NSObject>

@optional

- (void)request:(ALMResourceRequest *)request error:(NSError *)error task:(NSURLSessionDataTask *)task;
- (void)request:(ALMResourceRequest *)request didLoadResource:(ALMResource *)resource;
- (void)request:(ALMResourceRequest *)request didLoadResources:(RLMResults *)resources;

- (void)request:(ALMResourceRequest *)request didFetchResource:(ALMResource *)resource task:(NSURLSessionDataTask *)task;
- (void)request:(ALMResourceRequest *)request didFetchResources:(RLMResults *)resources task:(NSURLSessionDataTask *)task;

- (void)request:(ALMResourceRequest *)request sortOrFilter:(RLMResults *)resources;

- (NSDictionary *)request:(ALMResourceRequest *)request modifyData:(NSDictionary *)data ofType:(Class)resourceClass toSaveIn:(RLMRealm *)realm;
- (BOOL)request:(ALMResourceRequest *)request shouldUseCustomCommitWitData:(NSDictionary *)data;
- (BOOL)request:(ALMResourceRequest *)request commit:(Class)resourceClass data:(NSDictionary *)data inRealm:(RLMRealm *)realm;

@end