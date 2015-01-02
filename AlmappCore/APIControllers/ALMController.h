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

typedef id (^ALMCommitResourceOperation)(RLMRealm*, Class, NSDictionary*);
typedef NSArray*(^ALMCommitResourcesOperation)(RLMRealm*, Class, NSArray*);
typedef NSArray*(^ALMCommitNestedResourcesOperation)(RLMRealm*, Class, Class, NSUInteger, NSArray*);

@interface ALMController : NSObject

@property (weak, nonatomic) id<ALMControllerDelegate> controllerDelegate;

/* Default is YES, change to NO if you want to keep the store on the memory. */
@property (assign) BOOL saveToPersistenceStore;

- (instancetype) init __attribute__((unavailable("Instanciate through ALMCore class")));

+ (id)controllerWithDelegate:(id<ALMControllerDelegate>)controllerDelegate;

- (AFHTTPRequestOperationManager*)requestManager;
- (RLMRealm*)requestRealm;

- (NSString*)resourcePathFor:(Class)resourceClass;
- (NSString*)resourcePathFor:(Class)resourceClass nestedInClass:(Class)parentClass withID:(NSUInteger)parentID;
- (NSString*)buildUrlWithPath:(NSString*)path resourceID:(NSUInteger)resourceID;
- (NSString*)buildUrlWithPath:(NSString*)path;

- (AFHTTPRequestOperation *)resourceForClass:(Class)rClass id:(NSUInteger)resourceID parameters:(id)parameters onSuccess:(void (^)(id result))onSuccess onFailure:(void (^)(NSError *error))onFailure ;

- (AFHTTPRequestOperation *)resourceForClass:(Class)rClass inPath:(NSString*)resourcePath id:(NSUInteger)resourceID parameters:(id)parameters onSuccess:(void (^)(id result))onSuccess onFailure:(void (^)(NSError *error))onFailure ;

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass inPath:(NSString*)resourcesPath parameters:(id)parameters onSuccess:(void (^)(NSArray *result))onSuccess onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass parameters:(id)parameters onSuccess:(void (^)(NSArray *result))onSuccess onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass nestedOnClass:(Class)parentClass withID:(NSUInteger)parentID parameters:(id)parameters onSuccess:(void (^)(NSArray *result))onSuccess onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass nestedOnParent:(ALMResource*)parent parameters:(id)parameters onSuccess:(void (^)(NSArray *result))onSuccess onFailure:(void (^)(NSError *error))onFailure;

- (ALMCommitResourceOperation)commitResource;

- (ALMCommitResourcesOperation)commitResources;

+ (Class)resourceType;

- (id)resourceOfClass:(Class)resourceClass withID:(NSUInteger)resourceID;
- (id)resourceInTemporalRealmOfClass:(Class)resourceClass withID:(NSUInteger)resourceID;


@end
