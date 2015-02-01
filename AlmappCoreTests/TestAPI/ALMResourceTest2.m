//
//  ALMResourceTest2.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceTest2.h"

@interface ALMResourceTest2 ()

@property (copy, nonatomic) void (^successForNested)(id parent, RLMResults *collection);
@property (copy, nonatomic) void (^success)(id result);
@property (strong, nonatomic) XCTestExpectation *expectation;

@end

@implementation ALMResourceTest2

- (void)testAuth {
    self.expectation = [self expectationWithDescription:@"asdasd"];
    
    ALMSession *session = [self testSession];
    
    ALMResourceRequest *req = [ALMResourceRequest request:^(ALMResourceRequest *r) {
        r.credential = session.credential;
        r.resourceClass = [ALMFaculty class];
        r.resourceID = 1;
        r.realmPath = [self testRealmPath];
        r.shouldLog = YES;
        
    } delegate:self];
    
    [self.controller FETCH:req];
    
    [self waitForExpectationsWithTimeout:self.timeout
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)testCollection {
    [self resources:[ALMFaculty class] path:nil params:nil onSuccess:^(RLMResults *resources) {
        NSLog(@"%@", resources);
    }];
}

- (void)testSingle {
    [self resource:[ALMPost class] id:1 path:nil params:nil onSuccess:^(id resource) {
        NSLog(@"%@", resource);
    }];
}


- (void)testPrivateResource {
    NSString *desc = [NSString stringWithFormat:@"session"];
    
    self.expectation = [self expectationWithDescription:desc];
    
    ALMResourceRequest *req = [ALMResourceRequest request:^(ALMResourceRequest *r) {
        r.credential = self.testSession.credential;
        r.resourceClass = [ALMUser class];
        r.customPath = @"me";
        r.realmPath = [self testRealmPath];
        r.shouldLog = YES;
        
    } delegate:self];
    
    [self.controller FETCH:req];
    
    [self waitForExpectationsWithTimeout:self.timeout
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];

}

- (void)resources:(Class)resourcesClass path:(NSString *)path params:(id)params onSuccess:(void (^)(RLMResults *))onSuccess {
    
    NSString *desc = [NSString stringWithFormat:@"ResourceRequest %@", resourcesClass];
    
    self.expectation = [self expectationWithDescription:desc];
    
    self.success = onSuccess;
    
    ALMResourceRequest *req = [ALMResourceRequest request:^(ALMResourceRequest *r) {
        r.resourceClass = resourcesClass;
        r.customPath = path;
        r.parameters = params;
        r.realmPath = [self testRealmPath];
        r.shouldLog = YES;
        
    } delegate:self];
    
    [self.controller FETCH:req];
    
    [self waitForExpectationsWithTimeout:self.timeout
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)resource:(Class)resourceClass id:(long long)resourceID path:(NSString *)path params:(id)params onSuccess:(void (^)(id))onSuccess {
    
    NSString *desc = [NSString stringWithFormat:@"ResourceRequest %@ - %lld", resourceClass, resourceID];
    
    self.expectation = [self expectationWithDescription:desc];
    
    self.success = onSuccess;
    
    ALMResourceRequest *req = [ALMResourceRequest request:^(ALMResourceRequest *r) {
        r.resourceClass = resourceClass;
        r.resourceID = resourceID;
        r.customPath = path;
        r.parameters = params;
        r.realmPath = [self testRealmPath];
        r.shouldLog = YES;
        
    } delegate:self];
    
    [self.controller FETCH:req];
    
    [self waitForExpectationsWithTimeout:self.timeout
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)request:(ALMResourceRequest *)request error:(NSError *)error task:(NSURLSessionDataTask *)task {
    XCTFail(@"Error performing request: %@", request);
    NSLog(@"%@", error);
    NSLog(@"%@", task);
    
    [_expectation fulfill];
}

- (void)request:(ALMResourceRequest *)request didLoadResource:(ALMResource *)resource {
    NSLog(@"didLoadResource: %@", resource);
}

- (void)request:(ALMResourceRequest *)request didLoadResources:(RLMResults *)resources {
    NSLog(@"didLoadResources: %@", resources);
}

- (void)request:(ALMResourceRequest *)request didFetchResource:(ALMResource *)resource task:(NSURLSessionDataTask *)task {
    NSLog(@"didFetchResource: %@", resource);
    XCTAssertNotNil(resource);
    XCTAssertFalse(resource.invalidated);
    if (self.success) {
        self.success(resource);
    }
    
    [_expectation fulfill];
}

- (void)request:(ALMResourceRequest *)request didFetchResources:(RLMResults *)resources task:(NSURLSessionDataTask *)task {
    NSLog(@"didFetchResources: %@", resources);
    XCTAssertNotNil(resources);
    XCTAssertNotEqual(resources.count, 0);
    if (self.success) {
        self.success(resources);
    }
    
    [_expectation fulfill];
}

- (void)request:(ALMResourceRequest *)request didFetchParent:(id)parent nestedCollection:(RLMResults *)collection {
    NSLog(@"didFetchParent %@ : %@", parent, collection);
    XCTAssertNotNil(parent);
    XCTAssertNotEqual(collection.count, 0);
    
    if (self.successForNested) {
        self.successForNested(parent, collection);
    }
    
    [_expectation fulfill];
}

- (void)request:(ALMResourceRequest *)request sortOrFilter:(RLMResults *)resources {
    NSLog(@"sortOrFilter %@", resources);
}

- (NSDictionary *)request:(ALMResourceRequest *)request modifyData:(NSDictionary *)data ofType:(Class)resourceClass toSaveIn:(RLMRealm *)realm {
    NSLog(@"modifyData %@", data);
    return data;
}

- (BOOL)request:(ALMResourceRequest *)request shouldUseCustomCommitWitData:(NSDictionary *)data {
    return NO;
}



@end
