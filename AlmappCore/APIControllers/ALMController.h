//
//  ALMController.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMControllerDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import <Realm/Realm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import "ALMCore.h"

@interface ALMController : NSObject

@property (weak, nonatomic) id<ALMControllerDelegate> controllerDelegate;

@property (strong, nonatomic, readonly) NSString* resourceSingleName;
@property (strong, nonatomic, readonly) NSString* resourcePluralName;

/* Default is YES, change to NO if you want to keep the store on the memory. */
@property (assign) BOOL saveToPersistenceStore;

- (id)initWithDelegate:(id<ALMControllerDelegate>)controllerDelegate;

- (NSString*)buildUrl;
- (NSString*)buildUrlForResource:(NSUInteger)resourceID;
- (NSString*)buildUrlWithPath:(NSString*)path resourceID:(NSUInteger)resourceID;
- (NSString*)buildUrlWithPath:(NSString*)path;

- (AFHTTPRequestOperation *)resource:(long)resourceID
                         parameters:(id)parameters
                          onSuccess:(void (^)(RLMObject *result))onSuccess
                          onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)resourcesFromPath:(NSString*)path
                               parameters:(id)parameters
                                onSuccess:(void (^)(NSArray *response))onSuccess
                                onFailure:(void (^)(NSError *error))onFailure;


-(RLMObject*)updateInRealm:(RLMRealm*)realm resource:(NSDictionary *)resource;
-(NSArray*)updateInRealm:(RLMRealm*)realm resources:(NSArray *)resources;

@end
