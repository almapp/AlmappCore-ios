//
//  ALMSingleRequest.h
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMRequest.h"

@interface ALMSingleRequest : ALMRequest

@property (assign, nonatomic) long long resourceID;
@property (readonly) ALMResource *resource;

@property (copy, nonatomic) void (^onLoad)(id loadedResource);
@property (copy, nonatomic) id (^afterFetchOperation)(NSURLSessionDataTask *task, id result , ALMSingleRequest *request);
@property (copy, nonatomic) void (^onFinish)(NSURLSessionDataTask *task, id resource);
@property (copy, nonatomic) id (^commitOperation)(RLMRealm *realm, Class resourceClass, NSDictionary *data);
@property (readonly, copy, nonatomic) id (^defaultCommitOperation)(RLMRealm *realm, Class resourceClass, NSDictionary *data);

+ (instancetype)request:(void(^)(ALMSingleRequest *builder))builderBlock;

+ (instancetype)request:(void(^)(ALMSingleRequest *builder))builderBlock
                 onLoad:(void(^)(id loadedResource))onLoad
               onFinish:(void(^)(NSURLSessionDataTask *task, id resource))onFinish
                onError:(void(^)(NSURLSessionDataTask *task, NSError* error))onError;

- (id)execCommit:(id)data;
- (void)execOnLoad;
- (void)execOnFinishWithTask:(NSURLSessionDataTask *)task;
- (id)execFetch:(NSURLSessionDataTask *)task fetchedData:(id)result;

+ (NSString *)pathFor:(Class)resourceClass id:(long long)resourceID;

@end
