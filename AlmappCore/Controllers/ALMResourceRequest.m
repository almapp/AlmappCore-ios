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

- (id)copyWithZone:(NSZone *)zone {
    ALMResourceRequest *newReq = [[ALMResourceRequest alloc] init];
    newReq.realmPath = self.realmPath;
    newReq.credential = self.credential;
    newReq.dispatchQueue = self.dispatchQueue;
    newReq.customPath = self.customPath;
    newReq.resourceID = self.resourceID;
    newReq.resourceClass = self.resourceClass;
    newReq.parameters = self.parameters;
    newReq.shouldLog = self.shouldLog;
    newReq.requestDelegate = self.requestDelegate;
    
    return newReq;
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

- (void)publishFetchedResources:(RLMResults *)resources withParent:(id)parent {
    if(_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:didFetchResources:withParent:)]) {
        [_requestDelegate request:self didFetchResources:resources withParent:parent];
    }
}

- (RLMResults *)sortOrFilterResources:(RLMResults *)resources {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:sortOrFilter:)]) {
        return [_requestDelegate request:self sortOrFilter:resources];
    }
    else {
        return resources;
    }
}

- (BOOL)commitData:(id)data {
    RLMRealm *realm = self.realm;
    BOOL success = NO;
    
    [realm beginWriteTransaction];
    
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *saved = [self commitMultiple:self.resourceClass data:data inRealm:realm];
        self.resourcesIDs = saved;
        success = (saved != nil && saved.count != 0);
    }
    else if ([data isKindOfClass:[NSDictionary class]]) {
        id saved = [self commitSingle:self.resourceClass data:data inRealm:realm];
        success = (saved != nil);
    }
    else {
        [self publishError:nil task:nil]; // TODO: error
        NSLog(@"Error");
        success = NO;
    }
    
    [realm commitWriteTransaction];
    
    return success;
}

- (NSArray *)commitMultiple:(Class)resourceClass data:(NSArray *)data inRealm:(RLMRealm *)realm {
    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:data.count];
    
    for (NSDictionary *object in data) {
        ALMResource * saveObject = [self commitSingle:resourceClass data:object inRealm:realm];
        if (saveObject) {
            [ids addObject:@(saveObject.resourceID)];
        }
        else {
            NSLog(@"Error on commitMultiple");
        }
    }
    return ids;
}

- (ALMResource *)commitSingle:(Class)resourceClass data:(NSDictionary *)data inRealm:(RLMRealm *)realm {
    NSDictionary *finalData = data;
    ALMResource *result = nil;
    
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:modifyData:ofType:toSaveIn:)]) {
        finalData = [_requestDelegate request:self modifyData:data ofType:resourceClass toSaveIn:realm];
    }
    
    BOOL customCommit = NO;
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:shouldUseCustomCommitWitData:)]) {
        customCommit = [_requestDelegate request:self shouldUseCustomCommitWitData:finalData];
    }
    
    if (customCommit) {
        result = [_requestDelegate request:self commit:resourceClass data:finalData inRealm:realm];
    }
    else {
        @try {
            result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:finalData];
        }
        @catch (NSException *exception) {
            NSLog(@"Error creating object %@: ", exception);
        }
    }
    
    return result;
}






@end
