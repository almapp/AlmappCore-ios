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
    if (!request.realm) {
        request.realm = [self defaultRealm];
    }
    
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
        self.resourceID = kDefaultID;
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

+ (NSString *)pathFor:(Class)resourceClass id:(long long)resourceID {
    NSString *path = [self pathFor:resourceClass];
    return (path != nil) ? [NSString stringWithFormat:@"%@/%lld", path, resourceID] : nil;
}

- (BOOL)validateRequest {
    if (![super validateRequest]) {
        return NO;
    }
    if (self.resourceID <= 0) {
        return NO;
    }
    return YES;
}


#pragma mark - Getters

- (NSString *)path {
    if (!super.path) {
        super.path = [self.class pathFor:self.resourceClass id:self.resourceID];
    }
    return super.path;
}

- (ALMResource *)resource {
    return [ALMResource objectOfType:self.resourceClass withID:self.resourceID inRealm:self.realm];
}

@end
