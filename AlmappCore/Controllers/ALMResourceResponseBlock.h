//
//  ALMResourceResponseBlock.h
//  AlmappCore
//
//  Created by Patricio López on 14-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceResponse.h"

@interface ALMResourceResponseBlock : ALMResourceResponse <ALMResponseDelegate>

+ (instancetype)response:(void(^)(ALMResourceResponseBlock *r))builderBlock;
+ (instancetype)response:(void(^)(ALMResourceResponseBlock *r))builderBlock
                onSuccess:(void (^)(id result, NSURLSessionDataTask *task))onSuccess
                onError:(void (^)(NSError *error, NSURLSessionDataTask *task))onError;

@property (nonatomic, copy) void (^onError)(NSError *error, NSURLSessionDataTask *task);
@property (nonatomic, copy) void (^onSuccess)(id responseObject, NSURLSessionDataTask *task);
@property (nonatomic, copy) id (^customSerialization)(ALMResource *resource);

@end
