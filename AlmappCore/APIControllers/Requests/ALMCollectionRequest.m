//
//  ALMCollectionRequest.m
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCollectionRequest.h"

@implementation ALMCollectionRequest

#pragma mark - Constructors

+ (instancetype)request:(void (^)(ALMCollectionRequest *))builderBlock {
    NSParameterAssert(builderBlock);
    
    ALMCollectionRequest *request = [[self alloc] init];
    
    builderBlock(request);
    
    return request;
}

+ (instancetype)request:(void (^)(ALMCollectionRequest *))builderBlock onLoad:(void (^)(RLMResults *))onLoad onFinish:(void (^)(NSURLSessionDataTask *, RLMResults *))onFinish onError:(void (^)(NSURLSessionDataTask *, NSError *))onError {
    
    ALMCollectionRequest *request = [self request:builderBlock];
    request.onLoad = onLoad;
    request.onFinish = onFinish;
    request.onError = onError;
    return request;
}


#pragma mark - Commit

- (NSArray *(^)(RLMRealm *, __unsafe_unretained Class, NSArray *))commitOperation {
    if (!_commitOperation) {
        _commitOperation = [self.class defaultCommitOperation];
    }
    return _commitOperation;
}

+ (NSArray *(^)(RLMRealm *, __unsafe_unretained Class, NSArray *))defaultCommitOperation {
    return  ^(RLMRealm *realm, Class resourceClass, NSArray *data) {
        [realm beginWriteTransaction];
        NSArray* collection = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONArray:) withObject:realm withObject:data];
        [realm commitWriteTransaction];
        
        return collection;
    };
}


#pragma mark - Execute blocks

- (id)execCommit:(id)data {
    return self.commitOperation(self.realm, self.resourceClass, data);
}

- (void)execOnLoad {
    if (self.onLoad) {
        self.onLoad(self.resources);
    }
}

- (void)execOnFinishWithTask:(NSURLSessionDataTask *)task {
    if (self.onFinish) {
        self.onFinish(task, self.resources);
    }
}

- (id)execFetch:(NSURLSessionDataTask *)task fetchedData:(id)result {
    return (self.afterFetchOperation) ? self.afterFetchOperation(task, result, self) : result;
}

#pragma mark - Methods

- (RLMResults *)resources {
    if (self.filteredAndSortedLoad) {
        __block ALMCollectionRequest *blockSelf = self;
        return self.filteredAndSortedLoad(blockSelf);
    } else {
        return [ALMResource allObjectsOfType:self.resourceClass inRealm:self.realm];
    }
}

- (BOOL)validateRequest {
    if (![super validateRequest]) {
        return NO;
    }
    return YES;
}

@end
