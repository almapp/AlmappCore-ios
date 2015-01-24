//
//  ALMCollectionRequest.h
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMRequest.h"

@interface ALMCollectionRequest : ALMRequest

@property (readonly) RLMResults *resources;

@property (copy, nonatomic) RLMResults* (^filteredAndSortedLoad)(ALMCollectionRequest *request);
@property (copy, nonatomic) void (^onFinish)(NSURLSessionDataTask *task, RLMResults *resource);
@property (copy, nonatomic) void (^onLoad)(RLMResults *resources);
@property (copy, nonatomic) id (^afterFetchOperation)(NSURLSessionDataTask *task, NSArray* results, ALMCollectionRequest *request);
@property (copy, nonatomic) NSArray* (^commitOperation)(RLMRealm *realm, Class resourceClass, NSArray *data);
@property (readonly, copy, nonatomic) NSArray* (^defaultCommitOperation)(RLMRealm *realm, Class resourceClass, NSArray *data);

+ (instancetype)request:(void(^)(ALMCollectionRequest *builder))builderBlock;

+ (instancetype)request:(void(^)(ALMCollectionRequest *builder))builderBlock
                 onLoad:(void(^)(RLMResults *loadedResources))onLoad
               onFinish:(void(^)(NSURLSessionDataTask *task, RLMResults *resources))onFinish
                onError:(void(^)(NSURLSessionDataTask *task, NSError* error))onError;

@end
