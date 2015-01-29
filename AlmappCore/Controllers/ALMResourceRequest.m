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
    return _resourceID <= 0;
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











- (void)publishError:(NSError *)error {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:error:)]) {
        [_requestDelegate request:self error:error];
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

- (void)publishFetchedResource:(ALMResource *)resource {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:didFetchResource:)]) {
        [_requestDelegate request:self didFetchResource:resource];
    }
}

- (void)publishFetchedResources:(RLMResults *)resources {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:didFetchResources:)]) {
        [_requestDelegate request:self didFetchResources:resources];
    }
}

- (void)sortOrFilterResources:(RLMResults *)resources {
    if (_requestDelegate && [_requestDelegate respondsToSelector:@selector(request:sortOrFilter:)]) {
        [_requestDelegate request:self sortOrFilter:resources];
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
