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

-(AFHTTPRequestOperation *)resourceForClass:(Class)rClass inPath:(NSString *)resourcePath id:(long)resourceID parameters:(id)parameters onSuccess:(void (^)(id))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([ALMController errorForInvalidClass:rClass]);
        return nil;
    }
    
    NSString* requestString = [self buildUrlWithPath:resourcePath resourceID:resourceID];
    if (requestString == nil) {
        onFailure([ALMController errorForInvalidPath:resourcePath]);
        return nil;
    }
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    ALMController * __weak weakSelf = self;
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSDictionary *dicc = responseObject;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            id result = weakSelf.commitResource(weakSelf.requestRealm, rClass, dicc);
                                                            onSuccess(result);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;

}

- (AFHTTPRequestOperation *)resourceForClass:(Class)rClass id:(long)resourceID parameters:(id)parameters onSuccess:(void (^)(id result))onSuccess onFailure:(void (^)(NSError *error))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        return nil;
    }
    
    NSString* resourcePath = [rClass performSelector:@selector(pluralForm)];
    
    return [self resourceForClass:rClass inPath:resourcePath id:resourceID parameters:parameters onSuccess:onSuccess onFailure:onFailure];
}


- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass inPath:(NSString *)resourcesPath parameters:(id)parameters onSuccess:(void (^)(NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        onFailure([ALMController errorForInvalidClass:rClass]);
        return nil;
    }
    
    NSString* requestString = [self buildUrlWithPath:resourcesPath];
    if (requestString == nil) {
        onFailure([ALMController errorForInvalidPath:resourcesPath]);
        return nil;
    }
    
    ALMController * __weak weakSelf = self;
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSArray *array = responseObject;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            NSArray *result = weakSelf.commitResources(weakSelf.requestRealm, rClass, array);
                                                            onSuccess(result);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;
}

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass parameters:(id)parameters onSuccess:(void (^)(NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    if ([rClass isSubclassOfClass:[ALMResource class]] == NO) {
        return nil;
    }
    
    NSString* resourcesPath = [rClass performSelector:@selector(pluralForm)];
    
    return [self resourceCollectionForClass:rClass inPath:resourcesPath parameters:parameters onSuccess:onSuccess onFailure:onFailure];
}


#pragma mark - Persistence

- (ALMCommitResourceOperation)commitResource {
    return (id)^(RLMRealm *realm, Class resourceClass, NSDictionary *data) {
        
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

#pragma mark - Errors 

+ (NSError*)errorForInvalidClass:(Class)invalidClass {
    return [NSError errorWithDomain:@"API Controller" code:100 userInfo:@{
                                                              NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ is not subclass of RLMResource", invalidClass]
                                                              }];
}

+ (NSError*)errorForInvalidPath:(NSString*)invalidPath {
    return [NSError errorWithDomain:@"API Controller" code:101 userInfo:@{
                                                                         NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ is not a valid URL path.", invalidPath]
                                                                         }];
}

#pragma mark - Subclasses methods

+ (Class)resourceType {
    [NSException raise:@"Invoked abstract method, must be overriden" format:@"Invoked abstract method"];
    return nil;
}


@end
