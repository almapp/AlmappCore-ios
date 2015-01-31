//
//  ALMResourceTest.m
//  AlmappCore
//
//  Created by Patricio López on 24-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceTest.h"

@implementation ALMResourceTest

- (void(^)(NSURLSessionDataTask *, NSError *)) errorBlock:(XCTestExpectation *)expectation class:(__unsafe_unretained Class)resourceClass {
    __block XCTestExpectation *blockExpectation = expectation;
    
    return ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error on %@: %@", resourceClass, error);
        XCTFail(@"Error performing request with %@", resourceClass);
        [blockExpectation fulfill];
    };
}

- (void)resource:(Class)resourceClass
              id:(long long)resourceID
            path:(NSString *)path
          params:(id)params
       onSuccess:(void(^)(id resource))onSuccess {
    
    /*
    XCTestExpectation *expectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.resourceClass = resourceClass;
        builder.resourceID = resourceID;
        builder.realmPath = [weakSelf testRealmPath];
        builder.customPath = path;
        builder.parameters = params;
        
    } onLoad:^(id loadedResource) {
        NSLog(@"Loaded: %@", loadedResource);
        // XCTAssertNil(loadedResource, @"Should not exist");
        
    } onFinish:^(NSURLSessionDataTask *task, id resource) {
        NSLog(@"Finished with: %@", resource);
        XCTAssertNotNil(resource, @"Should exist");
        if (onSuccess) {
            onSuccess(resource);
        }
        [expectation fulfill];
        
    } onError:[weakSelf errorBlock:expectation class:resourceClass]]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        [op cancel];
    }];
     */
}

- (void)resources:(Class)resourcesClass
            path:(NSString *)path
          params:(id)params
        onSuccess:(void (^)(RLMResults *))onSuccess {
    /*
    XCTestExpectation *expectation = [self expectationWithDescription:@"validGetMultipleResource"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMCollectionRequest request:^(ALMCollectionRequest *builder) {
        builder.resourceClass = resourcesClass;
        builder.realmPath = [weakSelf testRealmPath];
        builder.customPath = path;
        builder.parameters = params;
        
    } onLoad:^(RLMResults *loadedResources) {
        NSLog(@"Loaded: %@", loadedResources);
        
    } onFinish:^(NSURLSessionDataTask *task, RLMResults *resources) {
        NSLog(@"Finished with: %@", resources);
        XCTAssertNotNil(resources, @"Should exist");
        if (onSuccess) {
            onSuccess(resources);
        }
        [expectation fulfill];
        
    } onError:[weakSelf errorBlock:expectation class:resourcesClass]]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        [op cancel];
    }];*/
}

- (void)nestedResources:(Class)resourcesClass
                     on:(Class)parentClass
                     id:(long long)parentID
                   path:(NSString *)path
                 params:(id)params
              onSuccess:(void (^)(id parent, RLMArray *results))onSuccess {
    /*
    XCTestExpectation *expectation = [self expectationWithDescription:@"validGetMultipleResource"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMNestedCollectionRequest request:^(ALMNestedCollectionRequest *builder) {
        builder.realmPath = weakSelf.testRealmPath;
        builder.parentClass = parentClass;
        builder.parentID = parentID;
        builder.resourceClass = resourcesClass;
        builder.customPath = path;
        builder.parameters = params;
        
    } onLoad:^(id parent, RLMArray *resources) {
        NSLog(@"Loaded parent: %@", parent);
        NSLog(@"Loaded collection: %@", resources);
        
    } onFinish:^(NSURLSessionDataTask *task, id parent, RLMArray *resources) {
        NSLog(@"Loaded parent: %@", parent);
        NSLog(@"Loaded collection with %lul elements", (unsigned long)resources.count);
        
        XCTAssertNotNil(resources, @"Should exist");
        XCTAssertNotNil(parent, @"Should exist");
        if (onSuccess) {
            onSuccess(parent, resources);
        }
        [expectation fulfill];
        
    } onError:[weakSelf errorBlock:expectation class:resourcesClass]]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        [op cancel];
    }];*/
}


@end