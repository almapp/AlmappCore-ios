//
//  ALMSingleRequest.m
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSingleRequest.h"

@implementation ALMSingleRequest

#pragma mark - Constructors

+ (instancetype)request:(void (^)(ALMSingleRequest *))builderBlock {
    NSParameterAssert(builderBlock);
    
    ALMSingleRequest *request = [[self alloc] init];
    
    builderBlock(request);
    
    return request;
}

+ (instancetype)request:(void (^)(ALMSingleRequest *))builderBlock onLoad:(void (^)(id))onLoad onFinish:(void (^)(NSURLSessionDataTask *, id))onFinish onError:(void (^)(NSURLSessionDataTask *, NSError *))onError {
    
    ALMSingleRequest *request = [self request:builderBlock];
    request.onLoad = onLoad;
    request.onFinish = onFinish;
    request.onError = onError;
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.resourceID = kDefaultRequestID;
    }
    return self;
}


#pragma mark - Commit

- (id (^)(RLMRealm *, __unsafe_unretained Class, NSDictionary *))commitOperation {
    if(!_commitOperation) {
        _commitOperation = [self.class defaultCommitOperation];
    }
    return _commitOperation;
}

+ (id (^)(RLMRealm *, __unsafe_unretained Class, NSDictionary *))defaultCommitOperation {
    return ^(RLMRealm *realm, Class resourceClass, NSDictionary *data) {
        
        [realm beginWriteTransaction];
        id result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:data];
        [realm commitWriteTransaction];
        
        return result;
    };
}


#pragma mark - Execute blocks

- (id)execCommit:(id)data {
    return self.commitOperation(self.realm, self.resourceClass, data);
}

- (void)execOnLoad {
    if (self.onLoad) {
        self.onLoad(self.resource);
    }
}

- (void)execOnFinishWithTask:(NSURLSessionDataTask *)task {
    if (self.onFinish) {
        self.onFinish(task, self.resource);
    }
}

- (id)execFetch:(NSURLSessionDataTask *)task fetchedData:(id)result {
    return (self.afterFetchOperation) ? self.afterFetchOperation(task, result, self) : result;
}


#pragma mark - Methods

+ (NSString *)intuitedPathFor:(Class)resourceClass withID:(long long)resourceID {
    return [NSString stringWithFormat:@"%@/%lld", [self.class intuitedPathFor:resourceClass], resourceID];
}

- (NSString *)intuitedPath {
    return [self.class intuitedPathFor:self.resourceClass withID:self.resourceID];
}

- (BOOL)validateRequest {
    if (![super validateRequest]) {
        return NO;
    }
    if (!self.customPath && self.resourceID <= 0) {
        return NO;
    }
    return YES;
}


#pragma mark - Getters

- (ALMResource *)resource {
    return [ALMResource objectOfType:self.resourceClass withID:self.resourceID inRealm:self.realm];
}

@end
