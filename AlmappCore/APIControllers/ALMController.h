//
//  ALMController.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <Realm/Realm.h>
#import <Realm+JSON/RLMObject+JSON.h>

#import "ALMControllerDelegate.h"
#import "ALMResource.h"


#pragma mark - Definitions

typedef id (^ALMCommitResourceOperation)(RLMRealm*, Class, NSDictionary*);
typedef NSArray*(^ALMCommitResourcesOperation)(RLMRealm*, Class, NSArray*);
typedef NSArray*(^ALMCommitNestedResourcesOperation)(RLMRealm*, Class, ALMResource*, NSArray*);

@interface ALMController : NSObject


#pragma mark - Properties

@property (weak, nonatomic) id<ALMControllerDelegate> controllerDelegate;

/* Default is YES, change to NO if you want to keep the store on the memory. */
@property (assign) BOOL saveToPersistenceStore;


# pragma mark - Constructors

- (instancetype) init __attribute__((unavailable("Instanciate through ALMCore class")));

+ (id)controllerWithDelegate:(id<ALMControllerDelegate>)controllerDelegate;


#pragma mark - Managers

- (AFHTTPRequestOperationManager*)requestManager;
- (RLMRealm*)requestRealm;


#pragma mark - Paths & URLs

- (NSString*)resourcePathFor:(Class)resourceClass;
- (NSString*)resourcePathFor:(Class)resourceClass nestedInClass:(Class)parentClass withID:(long long)parentID;
- (NSString*)buildUrlWithPath:(NSString*)path resourceID:(long long)resourceID;
- (NSString*)buildUrlWithPath:(NSString*)path;


#pragma mark - Fetch methods

- (AFHTTPRequestOperation *)resource:(Class)rClass
                                  id:(long long)resourceID
                          parameters:(id)parameters
                           onSuccess:(void (^)(id result))onSuccess
                           onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)resource:(Class)rClass
                              inPath:(NSString*)resourcePath
                                  id:(long long)resourceID
                          parameters:(id)parameters
                           onSuccess:(void (^)(id result))onSuccess
                           onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)resourceCollection:(Class)rClass
                                    parameters:(id)parameters
                                     onSuccess:(void (^)(NSArray *result))onSuccess
                                     onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)resourceCollection:(Class)rClass
                                        inPath:(NSString*)resourcesPath
                                    parameters:(id)parameters
                                     onSuccess:(void (^)(NSArray *result))onSuccess
                                     onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)nestedResourceCollection:(Class)rClass
                                            nestedOn:(ALMResource*)parent
                                          parameters:(id)parameters
                                           onSuccess:(void (^)(id parent, NSArray *result))onSuccess
                                           onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)nestedResourceCollection:(Class)rClass
                                            nestedOn:(Class)parentClass
                                              withID:(long long)parentID
                                          parameters:(id)parameters
                                           onSuccess:(void (^)(id parent, NSArray *result))onSuccess
                                           onFailure:(void (^)(NSError *error))onFailure;


#pragma mark - Persistence: commit operations

- (ALMCommitResourceOperation)commitResource;
- (ALMCommitResourcesOperation)commitResources;
- (ALMCommitNestedResourcesOperation)commitNestedResources;


#pragma mark - Persistence: load resources

- (id)loadResourceOfClass:(Class)resourceClass withID:(long long)resourceID;
- (id)loadResourceOfClass:(Class)resourceClass withID:(long long)resourceID onTemporalRealm:(BOOL)loadFromTemporal;
+ (NSArray *)sortResources:(RLMResults *)resources onProperty:(NSString *)property withValues:(NSArray *)preferedOrder;

@end
