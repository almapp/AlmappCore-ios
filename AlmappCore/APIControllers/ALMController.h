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

@interface ALMController : NSObject

@property (weak, nonatomic) id<ALMControllerDelegate> controllerDelegate;

/* Default is YES, change to NO if you want to keep the store on the memory. */
@property (assign) BOOL saveToPersistenceStore;

- (instancetype) init __attribute__((unavailable("Instanciate through ALMCore class")));

+ (instancetype)controllerWithDelegate:(id<ALMControllerDelegate>)controllerDelegate;

- (NSString*)buildUrlWithPath:(NSString*)path resourceID:(NSUInteger)resourceID;
- (NSString*)buildUrlWithPath:(NSString*)path;

- (AFHTTPRequestOperation *)resourceForClass:(Class)rClass id:(long)resourceID parameters:(id)parameters onSuccess:(void (^)(id result))onSuccess onFailure:(void (^)(NSError *error))onFailure ;

- (AFHTTPRequestOperation *)resourceForClass:(Class)rClass inPath:(NSString*)resourcePath id:(long)resourceID parameters:(id)parameters onSuccess:(void (^)(id result))onSuccess onFailure:(void (^)(NSError *error))onFailure ;

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass inPath:(NSString*)resourcesPath parameters:(id)parameters onSuccess:(void (^)(NSArray *result))onSuccess onFailure:(void (^)(NSError *error))onFailure ;

- (AFHTTPRequestOperation *)resourceCollectionForClass:(Class)rClass parameters:(id)parameters onSuccess:(void (^)(NSArray *result))onSuccess onFailure:(void (^)(NSError *error))onFailure ;

+ (Class)resourceType;

@end
