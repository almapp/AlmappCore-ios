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

- (NSString*)resourcePathFor:(Class)resourceClass nestedInClass:(Class)parentClass withID:(NSUInteger)parentID {
    NSString* parentPath = [self resourcePathFor:parentClass];
    NSString* childPath = [self resourcePathFor:resourceClass];
    NSString* fullPath = [NSString stringWithFormat:@"%@/%lu/%@", parentPath, (unsigned long)parentID, childPath];
    return [self buildUrlWithPath:fullPath];
}

- (NSString*)cleanUrl:(NSString*)dirtyUrl {
    return dirtyUrl;
}

- (NSString *)buildUrlWithPath:(NSString *)path resourceID:(NSUInteger)resourceID {
    NSString* cleanedPath = [self cleanUrl:path];
    if (cleanedPath != nil) {
        return [[self buildUrlWithPath:path] stringByAppendingString:[NSString stringWithFormat:@"/%ld", resourceID]];
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

-(AFHTTPRequestOperation *)resourceForClass:(Class)rClass inPath:(NSString *)resourcePath id:(NSUInteger)resourceID parameters:(id)parameters onSuccess:(void (^)(id))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([self errorForInvalidClass:rClass]);
        return nil;
    }
    
    NSString* requestString = resourcePath;
    if(requestString == nil) {
        requestString = [self resourcePathFor:rClass];
    }
    
    requestString = [self buildUrlWithPath:requestString resourceID:resourceID];
    NSLog(@"%@", requestString);
    if (requestString == nil) {
        onFailure([self errorForInvalidPath:resourcePath]);
        return nil;
    }
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    ALMController * __weak weakSelf = self;
    Class __block blockResourceClass = rClass;
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSDictionary *dicc = responseObject;
                                                        id result = weakSelf.commitResource(weakSelf.requestRealm, blockResourceClass, dicc);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            onSuccess(result);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;

}

- (AFHTTPRequestOperation *)resourceForClass:(Class)rClass id:(NSUInteger)resourceID parameters:(id)parameters onSuccess:(void (^)(id result))onSuccess onFailure:(void (^)(NSError *error))onFailure {
    
    return [self resourceForClass:rClass inPath:nil id:resourceID parameters:parameters onSuccess:onSuccess onFailure:onFailure];
}


- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass inPath:(NSString *)resourcesPath parameters:(id)parameters onSuccess:(void (^)(NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([self errorForInvalidClass:rClass]);
        return nil;
    }
    
    NSString* requestString = resourcesPath;
    if(requestString == nil) {
        requestString = [self resourcePathFor:rClass];
    }
    
    requestString = [self buildUrlWithPath:requestString];
    NSLog(@"%@", requestString);
    if (requestString == nil) {
        onFailure([self errorForInvalidPath:resourcesPath]);
        return nil;
    }
    
    ALMController * __weak weakSelf = self;
    Class __block blockResourceClass = rClass;
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSArray *array = responseObject;
                                                        NSArray *result = weakSelf.commitResources(weakSelf.requestRealm, blockResourceClass, array);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            onSuccess(result);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;
}

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass parameters:(id)parameters onSuccess:(void (^)(NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    return [self resourceCollectionForClass:rClass inPath:nil parameters:parameters onSuccess:onSuccess onFailure:onFailure];
}

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass nestedOnClass:(Class)parentClass withID:(NSUInteger)parentID parameters:(id)parameters onSuccess:(void (^)(NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([self errorForInvalidClass:rClass]);
        return nil;
    }
    
    if ([parentClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([self errorForInvalidClass:parentClass]);
        return nil;
    }
    
    NSString* requestString = [self resourcePathFor:rClass nestedInClass:parentClass withID:parentID];
    NSLog(@"%@", requestString);
    
    ALMController * __weak weakSelf = self;
    Class __block blockResourceClass = rClass;
    Class __block blockParentClass = parentClass;
    NSUInteger __block blockParentID = parentID;
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSArray *array = responseObject;
                                                        NSArray *result = weakSelf.commitNestedResources(weakSelf.requestRealm, blockResourceClass, blockParentClass, blockParentID, array);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            onSuccess(result);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;

}

-(AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass nestedOnParent:(ALMResource *)parent parameters:(id)parameters onSuccess:(void (^)(NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    return [self resourceCollectionForClass:rClass nestedOnClass:[parent class] withID:parent.resourceID parameters:nil onSuccess:onSuccess onFailure:onFailure];
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
    return ^(RLMRealm* realm, Class resourceClass, Class parentClass, NSUInteger parentID, NSArray* data) {

        ALMResource* parent = [ALMResource objectInRealm:realm ofType:parentClass withID:parentID];
        
        NSString* nestedCollectionName = [resourceClass performSelector:@selector(realmPluralForm)];
        
        // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
        SEL collectionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@", nestedCollectionName]);
        IMP imp = [parent methodForSelector:collectionSelector];
        RLMArray* (*func)(id, SEL) = (void*)imp;
        RLMArray *parentNestedResourcecollection = func(parent, collectionSelector);
        
        [realm beginWriteTransaction];
        NSArray* collection = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONArray:) withObject:realm withObject:data];
        [parentNestedResourcecollection addObjects:collection];
        [realm commitWriteTransaction];
        
        return collection;
    };
}

#pragma mark - Errors 

- (NSError*)errorForInvalidClass:(Class)invalidClass {
    return [NSError errorWithDomain:@"API Controller" code:100 userInfo:@{
                                                              NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ is not subclass of RLMResource", invalidClass]
                                                              }];
}

- (NSError*)errorForInvalidPath:(NSString*)invalidPath {
    return [NSError errorWithDomain:@"API Controller" code:101 userInfo:@{
                                                                         NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ is not a valid URL path.", invalidPath]
                                                                         }];
}

#pragma mark - Getting resources

- (id)resourceInTemporalRealmOfClass:(Class)resourceClass withID:(NSUInteger)resourceID {
    return [self resourceOfClass:resourceClass withID:resourceID inRealm:[self requestTemporalRealm]];
}

- (id)resourceOfClass:(Class)resourceClass withID:(NSUInteger)resourceID {
    return [self resourceOfClass:resourceClass withID:resourceID inRealm:[self requestDefaultRealm]];
}

- (id)resourceOfClass:(Class)resourceClass withID:(NSUInteger)resourceID inRealm:(RLMRealm*)realm {
    return [ALMResource objectInRealm:realm ofType:resourceClass withID:resourceID];
}

@end
