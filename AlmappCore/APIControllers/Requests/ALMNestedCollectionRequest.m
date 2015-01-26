//
//  ALMNestedCollectionRequest.m
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMNestedCollectionRequest.h"
#import "ALMRequestManager.h"
#import "ALMSingleRequest.h"
#import "ALMCollectionRequest.h"

@interface ALMNestedCollectionRequest ()

@property (strong, nonatomic) RLMResults *fetchedCollection;

@end

@implementation ALMNestedCollectionRequest

#pragma mark - Constructors

+ (instancetype)request:(void (^)(ALMNestedCollectionRequest *))builderBlock {
    NSParameterAssert(builderBlock);
    ALMNestedCollectionRequest *request = [[self alloc] init];
    builderBlock(request);
    
    [request setCustomRequestTask:^NSURLSessionDataTask *(ALMRequestManager *manager, ALMRequest *originalRequest) {
        if ([originalRequest isKindOfClass:[ALMNestedCollectionRequest class]]) {
            __block ALMNestedCollectionRequest* nestedRequest = (ALMNestedCollectionRequest*)originalRequest;
            
            void (^errorBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@", error);
                nestedRequest.onError(task, error);
            };
            
            void (^joinBlock)(ALMNestedCollectionRequest *, id, RLMResults *) = ^(ALMNestedCollectionRequest *request, id loadedParent, RLMResults *loadedCollection) {
                if (loadedParent) {
                    request.parent = loadedParent;
                }
                if (loadedCollection) {
                    request.fetchedCollection = loadedCollection;
                }
                
                if (request.parent && request.didLoadNestedCollection) {
                    BOOL success = request.associationOperation(request, request.parent, request.fetchedCollection);
                    if (success) {
                        request.onFinish(nil, request.parent, request.resources);
                    }
                }
            };
            
            [manager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
                builder.session = nestedRequest.session;
                builder.realmPath = nestedRequest.realmPath;
                builder.resourceClass = nestedRequest.parentClass;
                builder.commitOperation = nestedRequest.parentCommitOperation;
                builder.resourceID = nestedRequest.parentID;
                
            } onLoad:^(id loadedResource) {
                
            } onFinish:^(NSURLSessionDataTask *task, id resource) {
                joinBlock(nestedRequest, resource, nil);
                
            } onError:errorBlock]];
            
            NSURLSessionDataTask *nestedTask = [manager GET:[ALMCollectionRequest request:^(ALMCollectionRequest *builder) {
                builder.session = nestedRequest.session;
                builder.realmPath = nestedRequest.realmPath;
                builder.resourceClass = nestedRequest.resourceClass;
                builder.parameters = nestedRequest.parameters;
                builder.commitOperation = nestedRequest.nestedCommitOperation;
                builder.customPath = nestedRequest.path;
                
            } onLoad:^(RLMResults *loadedResources) {
                
            } onFinish:^(NSURLSessionDataTask *task, RLMResults *resources) {
                joinBlock(nestedRequest, nil, resources);
                
            } onError:errorBlock]];
            
            return nestedTask;
        }
        else {
            return nil;
        }
        
    }];
    
    return request;
}

+ (instancetype)request:(void (^)(ALMNestedCollectionRequest *))builderBlock onLoad:(void (^)(id, RLMArray *))onLoad onFinish:(void (^)(NSURLSessionDataTask *, id, RLMArray *))onFinish onError:(void (^)(NSURLSessionDataTask *, NSError *))onError {

    ALMNestedCollectionRequest *request = [self request:builderBlock];
    request.onLoad = onLoad;
    request.onFinish = onFinish;
    request.onError = onError;
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.parentID = kDefaultRequestID;
    }
    return self;
}

#pragma mark - Commit

- (id (^)(RLMRealm *, __unsafe_unretained Class, NSDictionary *))parentCommitOperation {
    if (!_parentCommitOperation) {
        _parentCommitOperation = [ALMSingleRequest defaultCommitOperation];
    }
    return _parentCommitOperation;
}

- (NSArray *(^)(RLMRealm *, __unsafe_unretained Class, NSArray *))nestedCommitOperation {
    if (!_nestedCommitOperation) {
        _nestedCommitOperation = [ALMCollectionRequest defaultCommitOperation];
    }
    return _nestedCommitOperation;
}

- (BOOL(^)(ALMNestedCollectionRequest *, ALMResource *, RLMResults *))associationOperation {
    if (!_associationOperation) {
        _associationOperation = [self.class defaultAssociationOperation];
    }
    return _associationOperation;
}

+ (BOOL(^)(ALMNestedCollectionRequest *, ALMResource *, RLMResults *))defaultAssociationOperation {
    return ^(ALMNestedCollectionRequest *request, ALMResource *parent, RLMResults *collection) {
        RLMRealm *realm = request.realm;
        
        NSString *nestedCollectionName = [request.resourceClass performSelector:@selector(realmPluralForm)];
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
    };
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
    return nil;
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

- (RLMArray *)resources {
    NSString *nestedCollectionName = [self.resourceClass performSelector:@selector(realmPluralForm)];
    SEL collectionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@", nestedCollectionName]);
    
    ALMResource *parent = self.parent;
    if ([parent respondsToSelector:collectionSelector]) {
        IMP imp = [parent methodForSelector:collectionSelector];
        RLMArray* (*func)(id, SEL) = (void*)imp;
        return func(parent, collectionSelector);
    }
    else {
        return nil;
    }
}

- (void)setParent:(ALMResource *)parent {
    _parentClass = parent.class;
    _parentID = parent.resourceID;
}

- (ALMResource *)parent {
    return [ALMResource objectOfType:_parentClass withID:_parentID inRealm:self.realm];
}

- (BOOL)isNestedCollection {
    return self.parentClass != NULL;
}

+ (NSString *)intuitedPathFor:(Class)resourceClass inParent:(Class)parentClass parentID:(long long)parentID {
    NSString* parentPath = [self intuitedPathFor:parentClass];
    NSString* childPath = [self intuitedPathFor:resourceClass];
    return [NSString stringWithFormat:@"%@/%lld/%@", parentPath, parentID, childPath];
}

- (NSString *)intuitedPath {
    if ([self isNestedCollection]) {
        return [self.class intuitedPathFor:self.resourceClass inParent:self.parentClass parentID:self.parentID];
    }
    else {
        return [super intuitedPath];
    }
}

- (BOOL)didLoadNestedCollection {
    return self.fetchedCollection != nil;
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
