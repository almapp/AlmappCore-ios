//
//  ALMResourceTest.m
//  AlmappCore
//
//  Created by Patricio López on 24-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceTest.h"

@implementation ALMResourceTest



- (void(^)(NSError *, NSURLSessionDataTask *)) errorBlock:(XCTestExpectation *)expectation class:(__unsafe_unretained Class)resourceClass {
    __block XCTestExpectation *blockExpectation = expectation;
    
    return ^(NSError *error, NSURLSessionDataTask *task) {
        NSLog(@"Error on %@: %@", resourceClass, error);
        XCTFail(@"Error performing request with %@", resourceClass);
        [blockExpectation fulfill];
    };
}



- (void)POST:(ALMResource *)resource
            path:(NSString *)path
      credential:(ALMCredential *)credential
       onSuccess:(void (^)(id result))onSuccess {
    
    NSString *description = [NSString stringWithFormat:@"GET: %@", resource];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    

    [self.controller POST:[ALMResourceResponseBlock response:^(ALMResourceResponseBlock *builder) {
        builder.resource = resource;
        builder.credential = credential;
        builder.customPath = path;
        builder.shouldLog = YES;
        
    } onSuccess:^(id result, NSURLSessionDataTask *task) {
        NSLog(@"Finished with: %@", result);
        XCTAssertNotNil(result, @"Should exist");
        if (onSuccess) {
            onSuccess(result);
        }
        [expectation fulfill];
        
    } onError:[self errorBlock:expectation class:resource.class]]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}




- (void)resource:(Class)resourceClass id:(long long)resourceID path:(NSString *)path params:(id)params onSuccess:(void (^)(id))onSuccess {
    return [self resource:resourceClass id:resourceID path:path params:params credential:nil onSuccess:onSuccess];
}

- (void)resource:(Class)resourceClass
              id:(long long)resourceID
            path:(NSString *)path
          params:(id)params
      credential:(ALMCredential *)credential
       onSuccess:(void (^)(id))onSuccess {
    
    NSString *description = [NSString stringWithFormat:@"GET: %@ - %lldll", resourceClass, resourceID];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    __weak typeof(self) weakSelf = self;
    
    [self.controller FETCH:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *builder) {
        builder.resourceClass = resourceClass;
        builder.resourceID = resourceID;
        builder.realmPath = [weakSelf testRealmPath];
        builder.credential = credential;
        builder.customPath = path;
        builder.parameters = params;
        builder.shouldLog = YES;
        
    } onLoad:^(id result) {
        NSLog(@"Loaded: %@", result);
        
    } onFetch:^(id result, NSURLSessionDataTask *task) {
        NSLog(@"Finished with: %@", result);
        XCTAssertNotNil(result, @"Should exist");
        if (onSuccess) {
            onSuccess(result);
        }
        [expectation fulfill];
        
    } onError:[self errorBlock:expectation class:resourceClass]]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)resources:(Class)resourcesClass path:(NSString *)path params:(id)params onSuccess:(void (^)(RLMResults *))onSuccess {
    return [self resources:resourcesClass path:path params:params credential:nil onSuccess:onSuccess];
}

- (void)resources:(Class)resourcesClass
            path:(NSString *)path
           params:(id)params
       credential:(ALMCredential *)credential
        onSuccess:(void (^)(RLMResults *))onSuccess {
    
    NSString *description = [NSString stringWithFormat:@"GET: %@", resourcesClass];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    __weak typeof(self) weakSelf = self;
    
    [self.controller FETCH:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *builder) {
        builder.resourceClass = resourcesClass;
        builder.realmPath = [weakSelf testRealmPath];
        builder.customPath = path;
        builder.parameters = params;
        builder.shouldLog = YES;
        builder.credential = credential;
        
    } onLoad:^(id result) {
        NSLog(@"Loaded: %@", result);
        
    } onFetch:^(id result, NSURLSessionDataTask *task) {
        NSLog(@"Finished with: %@", result);
        XCTAssertNotNil(result, @"Should exist");
        if (onSuccess) {
            onSuccess(result);
        }
        [expectation fulfill];
        
    } onError:[self errorBlock:expectation class:resourcesClass]]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)nestedResources:(Class)resourcesClass as:(NSString *)collectionAlias on:(Class)parentClass id:(long long)parentID as:(NSString *)parentAlias path:(NSString *)path params:(id)params onSuccess:(void (^)(id, RLMResults *))onSuccess {
    
    return [self nestedResources:resourcesClass as:collectionAlias on:parentClass id:parentID as:parentAlias path:path params:params credential:nil onSuccess:onSuccess];
}

- (void)nestedResources:(Class)resourcesClass
                     as:(NSString *)collectionAlias
                     on:(Class)parentClass
                     id:(long long)parentID
                     as:(NSString *)parentAlias
                   path:(NSString *)path
                 params:(id)params
             credential:(ALMCredential *)credential
              onSuccess:(void (^)(id, RLMResults *))onSuccess {
    
    NSString *description = [NSString stringWithFormat:@"GET: %@ - %lld / %@", parentClass, parentID, resourcesClass];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    __weak typeof(self) weakSelf = self;
    
    [self.controller FETCH:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *r) {
        r.resourceClass = resourcesClass;
        r.realmPath = [weakSelf testRealmPath];
        r.parameters = params;
        r.shouldLog = YES;
        r.credential = credential;
        
    }] withParent:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *r) {
        r.resourceClass = parentClass;
        r.resourceID = parentID;
        r.shouldLog = YES;
        r.realmPath = [weakSelf testRealmPath];
        r.credential = credential;
        
    }] as:collectionAlias belongsToAs:parentAlias].then(^(id parent, RLMResults *collection) {
        NSLog(@"Loaded parent: %@", parent);
        NSLog(@"Loaded collection: %@", collection);
        
        XCTAssertNotNil(parent, @"Must return a parent");
        XCTAssertNotNil(collection, @"Must return a collection");

        if (onSuccess) {
            onSuccess(parent, collection);
        }
        
        [expectation fulfill];
    }).catch(^(NSError *error) {
        NSLog(@"Error %@", error);
        XCTFail(@"Error on nested request");
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


@end