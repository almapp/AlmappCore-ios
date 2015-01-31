//
//  ALMResourceRequestBlock.m
//  AlmappCore
//
//  Created by Patricio López on 31-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceRequestBlock.h"

@implementation ALMResourceRequestBlock

+ (instancetype)request:(void (^)(ALMResourceRequestBlock *))builderBlock {
    NSParameterAssert(builderBlock);
    
    ALMResourceRequestBlock *request = [[self alloc] init];
    request.requestDelegate = request;
    
    builderBlock(request);
    
    return request;
}

+ (instancetype)request:(void (^)(ALMResourceRequestBlock *))builderBlock onLoad:(void (^)(id))onLoad onFetch:(void (^)(id, NSURLSessionDataTask *))onFetch onError:(void (^)(NSError *, NSURLSessionDataTask *))onError {
    
    ALMResourceRequestBlock *request = [self request:builderBlock];
    request.onFetchResource = onFetch;
    request.onFetchResources = onFetch;
    request.onLoadResource = onLoad;
    request.onLoadResources = onLoad;
    return request;
}

- (void)request:(ALMResourceRequest *)request error:(NSError *)error task:(NSURLSessionDataTask *)task {
    if (_onError) {
        _onError(error, task);
    }
}

- (void)request:(ALMResourceRequest *)request didLoadResource:(ALMResource *)resource {
    if (_onLoadResource) {
        _onLoadResource(resource);
    }
}

- (void)request:(ALMResourceRequest *)request didLoadResources:(RLMResults *)resources {
    if (_onLoadResources) {
        _onLoadResources(resources);
    }
}

- (void)request:(ALMResourceRequest *)request didFetchResource:(ALMResource *)resource task:(NSURLSessionDataTask *)task {
    if (_onFetchResource) {
        _onFetchResource(resource, task);
    }
}

- (void)request:(ALMResourceRequest *)request didFetchResources:(RLMResults *)resources task:(NSURLSessionDataTask *)task {
    if (_onFetchResources) {
        _onFetchResources(resources, task);
    }

}

- (void)request:(ALMResourceRequest *)request sortOrFilter:(RLMResults *)resources {
    if (_sortAndFilterBlock) {
        _sortAndFilterBlock(resources);
    }
}

- (NSDictionary *)request:(ALMResourceRequest *)request modifyData:(NSDictionary *)data ofType:(Class)resourceClass toSaveIn:(RLMRealm *)realm {
    if (_modifyDataBlock) {
        return _modifyDataBlock(data, &resourceClass, realm); // TODO: test &
    }
    else {
        return data;
    }
}

- (BOOL)request:(ALMResourceRequest *)request shouldUseCustomCommitWitData:(NSDictionary *)data {
    return (_commitBlock != nil);
}

- (ALMResource *)request:(ALMResourceRequest *)request commit:(Class)resourceClass data:(NSDictionary *)data inRealm:(RLMRealm *)realm {
    return _commitBlock(resourceClass, data, realm);
}


@end
