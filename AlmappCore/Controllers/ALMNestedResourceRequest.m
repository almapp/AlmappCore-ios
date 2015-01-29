//
//  ALMNestedResourceRequest.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMNestedResourceRequest.h"

@interface ALMNestedResourceRequest ()

@property (assign, nonatomic) BOOL didFetchParent;

@end

@implementation ALMNestedResourceRequest

+ (ALMNestedResourceRequest *)requestNested:(void (^)(ALMNestedResourceRequest *))builderBlock delegate:(id<ALMRequestDelegate>)delegate {
    
    NSParameterAssert(builderBlock);
    
    ALMNestedResourceRequest *request = [[self alloc] init];
    request.requestDelegate = delegate;
    
    builderBlock(request);
    
    return request;
}

- (ALMResourceRequest *)requestParent {
    if (!_parentRequest) {
        _parentRequest = [ALMResourceRequest request:^(ALMResourceRequest *r) {
            r.resourceClass = self.parentClass;
            r.resourceID = self.parentID;
            r.customPath = self.parentCustomPath;
            r.realmPath = self.realmPath;
            r.session = self.session;
            r.shouldLog = self.shouldLog;
            r.dispatchQueue = self.dispatchQueue;
            
            
        } delegate:self];
    }
    return _parentRequest;
}

- (ALMResourceRequest *)nestedCollectionRequest {
    if (!_nestedCollectionRequest) {
        _nestedCollectionRequest = [ALMResourceRequest request:^(ALMResourceRequest *r) {
            r.resourceClass = self.resourceClass;
            r.resourceID = self.resourceID;
            r.customPath = self.customPath;
            r.realmPath = self.realmPath;
            r.session = self.session;
            r.shouldLog = self.shouldLog;
            r.dispatchQueue = self.dispatchQueue;
            r.parameters = self.parameters;
            r.resourcesIDs = self.resourcesIDs;
            
        } delegate:self];
    }
    return _nestedCollectionRequest;
}

- (void)request:(ALMResourceRequest *)request error:(NSError *)error task:(NSURLSessionDataTask *)task {
    [self publishError:error task:task];
}

- (void)request:(ALMResourceRequest *)request didLoadResource:(ALMResource *)resource {
    [self publishLoaded:resource];
}

- (void)request:(ALMResourceRequest *)request didLoadResources:(RLMResults *)resources {
    [self publishLoaded:resources];
}

- (void)request:(ALMResourceRequest *)request didFetchResource:(ALMResource *)resource task:(NSURLSessionDataTask *)task {
    [self relateParent:resource with:nil];
    if (self.resourcesIDs.count != 0) {
        RLMResults *collection = [ALMResource objectsOfType:self.resourceClass inRealm:resource.realm withIDs:self.resourcesIDs];
        [self relateParent:resource with:collection];
    }
    else {
        _didFetchParent = YES;
    }
    [self publishFetched:resource task:task];
}

- (void)request:(ALMResourceRequest *)request didFetchResources:(RLMResults *)resources task:(NSURLSessionDataTask *)task {
    if (_didFetchParent) {
        ALMResource *parent = [ALMResource objectOfType:self.parentClass withID:self.parentID inRealm:resources.realm];
        [self relateParent:parent with:resources];
    }
    else {
        [self setResourcesIDsWith:resources];
    }
    [self publishFetched:resources task:task];
}

- (BOOL)request:(ALMResourceRequest *)request shouldUseCustomCommitWitData:(NSDictionary *)data {
    return NO;
}

- (BOOL)relateParent:(ALMResource *)parent with:(RLMResults *)collection {
    RLMRealm *realm = self.realm;
    
    NSString *nestedCollectionName = [self.resourceClass performSelector:@selector(realmPluralForm)];
    NSString *resourceParentName = [[parent class] performSelector:@selector(realmSingleForm)];
    
    // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    SEL collectionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@", nestedCollectionName]);
    SEL parentSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [resourceParentName capitalizedString]]);
    
    [realm beginWriteTransaction];
    
    if ([parent respondsToSelector:collectionSelector]) {
        IMP imp = [parent methodForSelector:collectionSelector];
        RLMArray* (*func)(id, SEL) = (void*)imp;
        RLMArray *parentNestedResourcecollection = func(parent, collectionSelector);
        
        [parentNestedResourcecollection removeAllObjects];
        [parentNestedResourcecollection addObjects:collection];
    }
    
    for (ALMResource *resource in collection) {
        if([resource respondsToSelector:parentSelector]) {
            IMP imp = [resource methodForSelector:parentSelector];
            void (*func)(id, SEL, ALMResource*) = (void*)imp;
            func(resource, parentSelector, parent);
        }
    }
    
    [realm commitWriteTransaction];
    return YES;
}


- (void)setParent:(ALMResource *)parent {
    _parentClass = parent.class;
    _parentID = parent.resourceID;
}

- (ALMResource *)parent {
    return [ALMResource objectOfType:_parentClass withID:_parentID inRealm:self.realm];
}

+ (NSString *)intuitedPathFor:(Class)resourceClass inParent:(Class)parentClass parentID:(long long)parentID {
    NSString* parentPath = [self intuitedPathFor:parentClass];
    NSString* childPath = [self intuitedPathFor:resourceClass];
    return [NSString stringWithFormat:@"%@/%lld/%@", parentPath, parentID, childPath];
}

- (NSString *)intuitedPath {
    return [self.class intuitedPathFor:self.resourceClass inParent:self.parentClass parentID:self.parentID];
}

@end
