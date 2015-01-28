//
//  ALMNestedCollectionRequest.h
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMRequest.h"

@interface ALMNestedCollectionRequest : ALMRequest

@property (readonly) RLMArray *resources;
@property (strong, nonatomic) ALMResource *parent;
@property (strong, nonatomic) Class parentClass;
@property (assign, nonatomic) long long parentID;
@property (readonly) BOOL didLoadNestedCollection;

@property (copy, nonatomic) void (^onLoad)(id parent, RLMArray* resources);
@property (copy, nonatomic) void (^onFinish)(NSURLSessionDataTask *task, id parent, RLMArray* resources);
@property (copy, nonatomic) id (^afterFetchOperation)(NSURLSessionDataTask *task, id parent, NSArray* results);

@property (copy, nonatomic) id (^parentCommitOperation)(RLMRealm *realm, Class resourceClass, NSDictionary *data);
@property (copy, nonatomic) NSArray* (^nestedCommitOperation)(RLMRealm *realm, Class resourceClass, NSArray *data);
@property (copy, nonatomic) BOOL (^associationOperation)(ALMNestedCollectionRequest *request, ALMResource* loadedParent, RLMResults *loadedCollection);
+ (BOOL (^)(ALMNestedCollectionRequest *request, ALMResource* loadedParent, RLMResults *loadedCollection))defaultAssociationOperation;

+ (instancetype)request:(void(^)(ALMNestedCollectionRequest *builder))builderBlock;

+ (instancetype)request:(void(^)(ALMNestedCollectionRequest *builder))builderBlock
                 onLoad:(void(^)(id parent, RLMArray* resources))onLoad
               onFinish:(void(^)(NSURLSessionDataTask *task, id parent, RLMArray* resources))onFinish
                onError:(void(^)(NSURLSessionDataTask *task, NSError* error))onError;

+ (NSString *)intuitedPathFor:(Class)resourceClass inParent:(Class)parentClass parentID:(long long)parentID;

@end
