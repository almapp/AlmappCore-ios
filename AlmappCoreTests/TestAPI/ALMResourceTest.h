//
//  ALMResourceTest.h
//  AlmappCore
//
//  Created by Patricio López on 24-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMTestCase.h"

@interface ALMResourceTest : ALMTestCase

- (void(^)(NSError *, NSURLSessionDataTask *))errorBlock:(XCTestExpectation *)expectation class:(Class)resourceClass;

- (void)resource:(Class)resourceClass
              id:(long long)resourceID
            path:(NSString *)path
          params:(id)params
       onSuccess:(void(^)(id resource))onSuccess;

- (void)resource:(Class)resourceClass
              id:(long long)resourceID
            path:(NSString *)path
          params:(id)params
      credential:(ALMCredential *)credential
       onSuccess:(void(^)(id resource))onSuccess;

- (void)resources:(Class)resourcesClass
             path:(NSString *)path
           params:(id)params
        onSuccess:(void(^)(RLMResults *resources))onSuccess;

- (void)resources:(Class)resourcesClass
             path:(NSString *)path
           params:(id)params
       credential:(ALMCredential *)credential
        onSuccess:(void(^)(RLMResults *resources))onSuccess;

- (void)nestedResources:(Class)resourcesClass
                     as:(NSString *)collectionAlias
                     on:(Class)parentClass
                     id:(long long)parentID
                     as:(NSString *)parentAlias
                   path:(NSString *)path
                 params:(id)params
              onSuccess:(void (^)(id parent, RLMResults *results))onSuccess;

- (void)nestedResources:(Class)resourcesClass
                     as:(NSString *)collectionAlias
                     on:(Class)parentClass
                     id:(long long)parentID
                     as:(NSString *)parentAlias
                   path:(NSString *)path
                 params:(id)params
             credential:(ALMCredential *)credential
              onSuccess:(void (^)(id parent, RLMResults *results))onSuccess;

@end
