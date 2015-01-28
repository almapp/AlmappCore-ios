//
//  ALMResourceTest.h
//  AlmappCore
//
//  Created by Patricio López on 24-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMTestCase.h"

@interface ALMResourceTest : ALMTestCase

- (void(^)(NSURLSessionDataTask *, NSError *)) errorBlock:(XCTestExpectation *)expectation class:(Class)resourceClass;

- (void)resource:(Class)resourceClass
              id:(long long)resourceID
            path:(NSString *)path
          params:(id)params
       onSuccess:(void(^)(id resource))onSuccess;

- (void)resources:(Class)resourcesClass
             path:(NSString *)path
           params:(id)params
        onSuccess:(void(^)(RLMResults *resources))onSuccess;

- (void)nestedResources:(Class)resourcesClass
                     on:(Class)parentClass
                     id:(long long)parentID
                   path:(NSString *)path
                 params:(id)params
              onSuccess:(void (^)(id parent, RLMArray *results))onSuccess;

@end
