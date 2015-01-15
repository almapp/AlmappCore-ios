//
//  ALMController.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMController.h"

@interface ALMController ()

- (id)initWithDelegate:(id<ALMControllerDelegate>)controllerDelegate;

- (AFHTTPRequestOperationManager*)requestManager;
- (RLMRealm*)requestRealm;
- (RLMRealm*)requestTemporalRealm;
- (RLMRealm*)requestDefaultRealm;
- (NSError*)errorForInvalidClass:(Class)invalidClass;
- (NSError*)errorForInvalidPath:(NSString*)invalidPath;

@end

@implementation ALMController


#pragma mark - Constructors

+ (id)controllerWithDelegate:(id<ALMControllerDelegate>)controllerDelegate {
    return [[self alloc] initWithDelegate:controllerDelegate];
}


- (id)initWithDelegate:(id<ALMControllerDelegate>)controllerDelegate {
    self = [super init];
    if (self) {
        _controllerDelegate = controllerDelegate;
        _saveToPersistenceStore = YES;
    }
    return self;
}


#pragma mark - Managers

- (AFHTTPRequestOperationManager*)requestManager {
    return [_controllerDelegate requestManager];
}


- (RLMRealm *)requestDefaultRealm {
    return [_controllerDelegate requestRealm];
}


- (RLMRealm *)requestTemporalRealm {
    return [_controllerDelegate requestTemporalRealm];
}


- (RLMRealm *)requestRealm {
    return (_saveToPersistenceStore) ? [self requestDefaultRealm] : [self requestTemporalRealm];
}


#pragma mark - URL

- (NSString*)resourcePathFor:(Class)resourceClass {
    return [resourceClass performSelector:@selector(apiPluralForm)];
}

- (NSString*)resourcePathFor:(Class)resourceClass nestedInClass:(Class)parentClass withID:(long long)parentID {
    NSString* parentPath = [self resourcePathFor:parentClass];
    NSString* childPath = [self resourcePathFor:resourceClass];
    NSString* fullPath = [NSString stringWithFormat:@"%@/%lld/%@", parentPath, parentID, childPath];
    return [self buildUrlWithPath:fullPath];
}

- (NSString*)cleanUrl:(NSString*)dirtyUrl {
    return dirtyUrl;
}

- (NSString *)buildUrlWithPath:(NSString *)path resourceID:(long long)resourceID {
    NSString* cleanedPath = [self cleanUrl:path];
    if (cleanedPath != nil) {
        return [[self buildUrlWithPath:path] stringByAppendingString:[NSString stringWithFormat:@"/%lld", resourceID]];
    }
    else {
        return nil;
    }
}


- (NSString *)buildUrlWithPath:(NSString *)path {
    NSString* cleanedPath = [self cleanUrl:path];
    if (cleanedPath != nil) {
        return [NSString stringWithFormat:@"%@/%@", [_controllerDelegate baseURL], path];
    }
    else {
        return nil;
    }
}


#pragma mark - Requests operations

- (AFHTTPRequestOperation *)resource:(Class)rClass
                                  id:(long long)resourceID
                          parameters:(id)parameters
                           onSuccess:(void (^)(id result))onSuccess
                           onFailure:(void (^)(NSError *error))onFailure {
    
    return [self resource:rClass inPath:nil id:resourceID parameters:parameters onSuccess:onSuccess onFailure:onFailure];
}


- (AFHTTPRequestOperation *)resource:(Class)rClass
                              inPath:(NSString*)resourcePath
                                  id:(long long)resourceID
                          parameters:(id)parameters
                           onSuccess:(void (^)(id result))onSuccess
                           onFailure:(void (^)(NSError *error))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([self errorForInvalidClass:rClass]);
        return nil;
    }
    
    NSString* requestString = resourcePath;
    if(requestString == nil) {
        requestString = [self resourcePathFor:rClass];
    }
    
    requestString = [self buildUrlWithPath:requestString resourceID:resourceID];
    
    if (requestString == nil) {
        onFailure([self errorForInvalidPath:resourcePath]);
        return nil;
    }
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    ALMController * __weak weakSelf = self;
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSDictionary *dicc = responseObject;
                                                        id result = weakSelf.commitResource(weakSelf.requestRealm, rClass, dicc);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            onSuccess(result);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;
}


- (AFHTTPRequestOperation *)resourceCollection:(Class)rClass
                                    parameters:(id)parameters
                                     onSuccess:(void (^)(NSArray *result))onSuccess
                                     onFailure:(void (^)(NSError *error))onFailure{
    
    return [self resourceCollection:rClass inPath:nil parameters:parameters onSuccess:onSuccess onFailure:onFailure];
}


- (AFHTTPRequestOperation *)resourceCollection:(Class)rClass
                                        inPath:(NSString*)resourcesPath
                                    parameters:(id)parameters
                                     onSuccess:(void (^)(NSArray *result))onSuccess
                                     onFailure:(void (^)(NSError *error))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([self errorForInvalidClass:rClass]);
        return nil;
    }
    
    NSString* requestString = resourcesPath;
    if(requestString == nil) {
        requestString = [self resourcePathFor:rClass];
    }
    
    requestString = [self buildUrlWithPath:requestString];
    
    if (requestString == nil) {
        onFailure([self errorForInvalidPath:resourcesPath]);
        return nil;
    }
    
    ALMController * __weak weakSelf = self;
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSArray *array = responseObject;
                                                        NSArray *result = weakSelf.commitResources(weakSelf.requestRealm, rClass, array);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            onSuccess(result);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;
}


- (AFHTTPRequestOperation *)nestedResourceCollection:(Class)rClass
                                            nestedOn:(ALMResource*)parent
                                          parameters:(id)parameters
                                           onSuccess:(void (^)(id parent, NSArray *result))onSuccess
                                           onFailure:(void (^)(NSError *error))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([self errorForInvalidClass:rClass]);
        return nil;
    }
    /*
    if ([parentClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([self errorForInvalidClass:parentClass]);
        return nil;
    }
     */
    
    NSString* requestString = [self resourcePathFor:rClass nestedInClass:[parent class] withID:parent.resourceID];
    
    ALMController * __weak weakSelf = self;
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSArray *array = responseObject;
                                                        NSArray *result = weakSelf.commitNestedResources(weakSelf.requestRealm, rClass, parent, array);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            onSuccess(parent, result);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;
}


- (AFHTTPRequestOperation *)nestedResourceCollection:(Class)rClass
                                            nestedOn:(Class)parentClass
                                              withID:(long long)parentID
                                          parameters:(id)parameters
                                           onSuccess:(void (^)(id parent, NSArray *result))onSuccess
                                           onFailure:(void (^)(NSError *error))onFailure {
    
    ALMResource *parent = [parentClass objectInRealm:self.requestRealm forID:parentID];
    
    if(parent != nil) {
        return [self nestedResourceCollection:rClass nestedOn:parent parameters:parameters onSuccess:onSuccess onFailure:onFailure];
    }
    else {
        ALMController __weak *weakSelf = self;
        
        AFHTTPRequestOperation *parentFetch =  [self resource:parentClass id:parentID parameters:nil onSuccess:^(id result) {
            [weakSelf nestedResourceCollection:rClass nestedOn:result parameters:parameters onSuccess:onSuccess onFailure:onFailure];
            
        } onFailure:^(NSError *error) {
            onFailure(error);
        }];
        
        return parentFetch;
    }
}


#pragma mark - Persistence

- (ALMCommitResourceOperation)commitResource {
    return ^(RLMRealm *realm, Class resourceClass, NSDictionary *data) {
        
        [realm beginWriteTransaction];
        id result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:data];
        [realm commitWriteTransaction];
        
        return result;
    };
}

- (ALMCommitResourcesOperation)commitResources {
    return  ^(RLMRealm *realm, Class resourceClass, NSArray *data) {
        [realm beginWriteTransaction];
        NSArray* collection = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONArray:) withObject:realm withObject:data];
        [realm commitWriteTransaction];
        
        return collection;
    };
}

- (ALMCommitNestedResourcesOperation)commitNestedResources {
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

#pragma mark - Errors 

- (NSError*)errorForInvalidClass:(Class)invalidClass {
    return [NSError errorWithDomain:@"API Controller"
                               code:100
                           userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ is not subclass of RLMResource", invalidClass]}];
}

- (NSError*)errorForInvalidPath:(NSString*)invalidPath {
    return [NSError errorWithDomain:@"API Controller"
                               code:101
                           userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ is not a valid URL path.", invalidPath]}];
}

#pragma mark - Getting resources

- (id)loadResourceOfClass:(Class)resourceClass withID:(long long)resourceID {
    return [self resourceOfClass:resourceClass withID:resourceID inRealm:[self requestDefaultRealm]];
}

- (id)loadResourceOfClass:(Class)resourceClass withID:(long long)resourceID onTemporalRealm:(BOOL)loadFromTemporal {
    RLMRealm *realm = loadFromTemporal ? [self requestTemporalRealm] : [self requestDefaultRealm];
    return [self resourceOfClass:resourceClass withID:resourceID inRealm:realm];
}

- (id)resourceOfClass:(Class)resourceClass withID:(long long)resourceID inRealm:(RLMRealm*)realm {
    return [resourceClass objectInRealm:realm forID:resourceID];
}

+ (NSArray *)sortResources:(RLMResults *)resources onProperty:(NSString *)property withValues:(NSArray *)preferedOrder {
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:resources.count];
    NSMutableArray* missingValues = [NSMutableArray array];
    
    for (int i = 0; i < resources.count; i++) {
        [results addObject:[NSNull null]];
    }
    
    for (id resource in resources) {
        id value = [resource valueForKey:property];
        NSUInteger index = [preferedOrder indexOfObject:value];
        if (index != NSNotFound) {
            [results replaceObjectAtIndex:index withObject:resource];
        }
        else {
            [missingValues addObject:resource];
        }
    }
    [results addObjectsFromArray:missingValues];
    return results;
}

@end
