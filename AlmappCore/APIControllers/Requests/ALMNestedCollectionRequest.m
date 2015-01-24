//
//  ALMNestedCollectionRequest.m
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMNestedCollectionRequest.h"

@implementation ALMNestedCollectionRequest

#pragma mark - Constructors

+ (instancetype)request:(void (^)(ALMNestedCollectionRequest *))builderBlock {
    NSParameterAssert(builderBlock);
    ALMNestedCollectionRequest *request = [[self alloc] init];
    builderBlock(request);
    if (!request.realm) {
        request.realm = [self defaultRealm];
    }
    
    return request;
}

+ (instancetype)request:(void (^)(ALMNestedCollectionRequest *))builderBlock onLoad:(void (^)(id, RLMResults *))onLoad onFinish:(void (^)(NSURLSessionDataTask *, id, RLMResults *))onFinish onError:(void (^)(NSURLSessionDataTask *, NSError *))onError {

    ALMNestedCollectionRequest *request = [self request:builderBlock];
    request.onLoad = onLoad;
    request.onFinish = onFinish;
    request.onError = onError;
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.parentID = kDefaultID;
    }
    return self;
}

#pragma mark - Commit

- (NSArray *(^)(RLMRealm *, __unsafe_unretained Class, ALMResource *, NSArray *))commitOperation {
    if (!_commitOperation) {
        _commitOperation = [self.class defaultCommitOperation];
    }
    return _commitOperation;
}

+ (NSArray *(^)(RLMRealm *, __unsafe_unretained Class, ALMResource *, NSArray *))defaultCommitOperation {
    return ^(RLMRealm* realm, Class resourceClass, ALMResource* parent, NSArray* data) {
        
        NSString *nestedCollectionName = [resourceClass performSelector:@selector(realmPluralForm)];
        NSString *resourceParentName = [[parent class] performSelector:@selector(realmSingleForm)];
        
        // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
        SEL collectionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@", nestedCollectionName]);
        SEL parentSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [resourceParentName capitalizedString]]);
        
        [realm beginWriteTransaction];
        
        NSArray* collection = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONArray:) withObject:realm withObject:data];
        
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
        
        return collection;
    };
}

#pragma mark - Execute blocks

- (id)execCommit:(id)data {
    return self.commitOperation(self.realm, self.resourceClass, self.parent, data);
}

- (void)execOnLoad {
    if (self.onLoad) {
        self.onLoad(self.parent, self.resources);
    }
}

- (void)execOnFinishWithTask:(NSURLSessionDataTask *)task {
    if (self.onFinish) {
        self.onFinish(task, self.parent, self.resources);
    }
}


#pragma mark - Methods

- (void)setParent:(ALMResource *)parent {
    _parentClass = parent.class;
    _parentID = parent.resourceID;
}

- (ALMResource *)parent {
    return [ALMResource objectOfType:_parentClass withID:_parentID inRealm:self.realm];
}

- (BOOL)isNestedCollection {
    return self.parentClass != NULL && self.parentID != kDefaultID;
}



+ (NSString *)pathFor:(Class)resourceClass inParent:(Class)parentClass parentID:(long long)parentID {
    NSString* parentPath = [self pathFor:parentClass];
    NSString* childPath = [self pathFor:resourceClass];
    return [NSString stringWithFormat:@"%@/%lld/%@", parentPath, parentID, childPath];
}

- (NSString *)path {
    if(!self.path) {
        if ([self isNestedCollection]) {
            return [self.class pathFor:self.resourceClass inParent:self.parentClass parentID:self.parentID];
        }
        else {
            return [self.class pathFor:self.resourceClass];
        }
    }
    return self.path;
}

- (BOOL)validateRequest {
    if (![super validateRequest]) {
        return NO;
    }
    if (![self.parentClass isSubclassOfClass:[ALMResource class]]) {
        return NO;
    }
    if (self.parentID <= 0) {
        return NO;
    }
    return YES;
}

@end
