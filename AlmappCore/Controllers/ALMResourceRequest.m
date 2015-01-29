//
//  ALMResourceRequest.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceRequest.h"

BOOL const kRequestForceLogin = NO;

@implementation ALMResourceRequest


+ (instancetype)request:(void (^)(ALMResourceRequest *))builderBlock delegate:(id<ALMRequestDelegate>)delegate {
    NSParameterAssert(builderBlock);
    
    ALMResourceRequest *request = [[self alloc] init];
    request.requestDelegate = delegate;
    
    builderBlock(request);
    
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.resourceID = 0;
        self.realmPath = [self.class defaultRealmPath];
    }
    return self;
}


- (BOOL)isRequestingACollection {
    if (!_requestCollection) {
        return _resourceID <= 0;
    }
    else {
        return _requestCollection;
    }
}


- (void)setRealm:(RLMRealm *)realm {
    _realmPath = (realm) ? realm.path : nil;
}

- (RLMRealm *)realm {
    return [RLMRealm realmWithPath:_realmPath];
}

+ (NSString *)defaultRealmPath {
    return [RLMRealm defaultRealmPath];
}

- (void)setResourcesIDsWith:(RLMResults *)resourcesIDs {
    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:resourcesIDs.count];
    for (ALMResource *resource in resourcesIDs) {
        [ids addObject:[NSNumber numberWithLongLong:resource.resourceID]];
    }
    _resourcesIDs = ids;
}


+ (NSString *)intuitedPathFor:(Class)resourceClass {
    if ([resourceClass instancesRespondToSelector:@selector(apiPluralForm)]) {
        return [resourceClass performSelector:@selector(apiPluralForm)];
    }
    else {
        return @"";
    }
}

+ (NSString *)intuitedPathFor:(Class)resourceClass withID:(long long)resourceID {
    return [NSString stringWithFormat:@"%@/%lld", [self intuitedPathFor:resourceClass], resourceID];
}

- (NSString *)intuitedPath {
    if (self.isRequestingACollection) {
        return [self.class intuitedPathFor:self.resourceClass];
    }
    else {
        return [self.class intuitedPathFor:self.resourceClass withID:self.resourceID];
    }
}


- (NSString *)path {
    return (_customPath) ? _customPath : self.intuitedPath;
}


- (dispatch_queue_t)dispatchQueue {
    if (!_dispatchQueue) {
        _dispatchQueue = dispatch_get_main_queue();
    }
    return _dispatchQueue;
}






- (void)publishError:(NSError *)error task:(NSURLSessionDataTask *)task {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:error:task:)]) {
        [_requestDelegate request:self error:error task:task];
    }
}

- (void)publishLoaded:(id)object {
    if (self.isRequestingACollection) {
        [self publishLoadedResources:object];
    }
    else {
        [self publishLoadedResource:object];
    }
}

- (void)publishLoadedResource:(ALMResource *)resource {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:didLoadResource:)]) {
        [_requestDelegate request:self didLoadResource:resource];
    }
}

- (void)publishLoadedResources:(RLMResults *)resources {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:didLoadResources:)]) {
        [_requestDelegate request:self didLoadResources:resources];
    }
}

- (void)publishFetched:(id)object task:(NSURLSessionDataTask *)task {
    if (self.isRequestingACollection) {
        [self publishFetchedResources:object task:task];
    }
    else {
        [self publishFetchedResource:object task:task];
    }
}

- (void)publishFetchedResource:(ALMResource *)resource task:(NSURLSessionDataTask *)task {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:didFetchResource:task:)]) {
        [_requestDelegate request:self didFetchResource:resource task:task];
    }
}

- (void)publishFetchedResources:(RLMResults *)resources task:(NSURLSessionDataTask *)task {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:didFetchResources:task:)]) {
        [_requestDelegate request:self didFetchResources:resources task:task];
    }
}

- (void)sortOrFilterResources:(RLMResults *)resources {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:sortOrFilter:)]) {
        [_requestDelegate request:self sortOrFilter:resources];
    }
}

- (BOOL)commitData:(id)data {
    RLMRealm *realm = self.realm;
    if ([data isKindOfClass:[NSArray class]]) {
        return [self commitMultiple:self.resourceClass data:data inRealm:realm];
    }
    else if ([data isKindOfClass:[NSDictionary class]]) {
        return [self commitSingle:self.resourceClass data:data inRealm:realm];
    }
    else {
        [self publishError:nil task:nil]; // TODO: error
        NSLog(@"Error");
        return NO;
    }
}

- (BOOL)commitMultiple:(Class)resourceClass data:(NSArray *)data inRealm:(RLMRealm *)realm {
    BOOL success = YES;
    for (NSDictionary *object in data) {
        BOOL saveObjectSuccess = [self commitSingle:resourceClass data:object inRealm:realm];
        if (!saveObjectSuccess) {
            success = NO;
        }
    }
    return success;
}

- (BOOL)commitSingle:(Class)resourceClass data:(NSDictionary *)data inRealm:(RLMRealm *)realm {
    NSDictionary *finalData = data;
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:modifyData:ofType:toSaveIn:)]) {
        finalData = [_requestDelegate request:self modifyData:data ofType:resourceClass toSaveIn:realm];
    }
    
    BOOL success = NO;
    BOOL customCommit = NO;
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:shouldUseCustomCommitWitData:)]) {
        customCommit = [_requestDelegate request:self shouldUseCustomCommitWitData:finalData];
    }
    
    if (customCommit) {
        success = [_requestDelegate request:self commit:resourceClass data:finalData inRealm:realm];
    }
    else {
        @try {
            id result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:finalData];
            success = (result != nil);
        }
        @catch (NSException *exception) {
            success = NO;
        }
    }
    
    return success;
}






@end
