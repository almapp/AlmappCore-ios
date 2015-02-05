//
//  ALMResourceRequestBlock.h
//  AlmappCore
//
//  Created by Patricio López on 31-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceRequest.h"

@interface ALMResourceRequestBlock : ALMResourceRequest <ALMRequestDelegate>

+ (instancetype)request:(void(^)(ALMResourceRequestBlock *r))builderBlock;
+ (instancetype)request:(void(^)(ALMResourceRequestBlock *r))builderBlock
                 onLoad:(void (^)(id result))onLoad
                onFetch:(void (^)(id result, NSURLSessionDataTask *task))onFetch
                onError:(void (^)(NSError *error, NSURLSessionDataTask *task))onError;

@property (nonatomic, copy) void (^onError)(NSError *error, NSURLSessionDataTask *task);

@property (nonatomic, copy) void (^onLoadResource)(ALMResource *resource);
@property (nonatomic, copy) void (^onLoadResources)(RLMResults *resources);

@property (nonatomic, copy) void (^onFetchResource)(ALMResource *resource, NSURLSessionDataTask *task);
@property (nonatomic, copy) void (^onFetchResources)(RLMResults *resources, NSURLSessionDataTask *task);
@property (nonatomic, copy) void (^onFetchResourcesWithParent)(id parent, RLMResults *resources);

@property (nonatomic, copy) RLMResults* (^sortAndFilterBlock)(RLMResults *resources);

@property (nonatomic, copy) NSDictionary * (^modifyDataBlock)(NSDictionary *data, Class *resourceClass, RLMRealm *realm);

@property (nonatomic, copy) ALMResource * (^commitBlock)(Class resourceClass, NSDictionary *data, RLMRealm *realm);

@end
