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
#import "AlmappCore.h"

@interface ALMController : NSObject

@property (weak, nonatomic) id<ALMControllerDelegate> controllerDelegate;

@property (strong, nonatomic, readonly) NSString* resourceSingleName;
@property (strong, nonatomic, readonly) NSString* resourcePluralName;

- (id)initWithDelegate:(id<ALMControllerDelegate>)controllerDelegate;

-(AFHTTPRequestOperation *)resource:(long)resourceID
                         parameters:(id)parameters
                          onSuccess:(void (^)(RLMObject *result))onSuccess
                          onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)resourcesWithParameters:(id)parameters
                                            success:(void (^)(RLMObject *response))success
                                            failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)subResourcesFor:(NSInteger *)resourceID
                            subResourceType:(NSString*)subResourceType
                                 parameters:(id)parameters
                                    success:(void (^)(RLMObject *response))success
                                    failure:(void (^)(NSError *error))failure;

-(RLMObject*)updateInRealm:(RLMRealm*)realm resource:(NSDictionary *)resource;
-(NSArray*)updateInRealm:(RLMRealm*)realm resources:(NSArray *)resources;

@end
