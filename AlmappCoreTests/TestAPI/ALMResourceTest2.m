//
//  ALMResourceTest2.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceTest2.h"

@interface ALMResourceTest2 ()

@property (copy, nonatomic) void (^success)(id result);
@property (strong, nonatomic) XCTestExpectation *expectation;

@end

@implementation ALMResourceTest2 




- (void)resource:(Class)resourceClass id:(long long)resourceID path:(NSString *)path params:(id)params onSuccess:(void (^)(id))onSuccess {
    
    NSString *desc = [NSString stringWithFormat:@"ResourceRequest %@ - %lld", resourceClass, resourceID];
    _expectation = [self expectationWithDescription:@"HTTP request"];
    
    [self.controller FETCH:[ALMResourceRequest request:^(ALMResourceRequest *r) {
        r.resourceClass = resourceClass;
        r.resourceID = resourceID;
        r.customPath = path;
        r.parameters = params;
        r.realmPath = [self testRealmPath];
        
    } delegate:self]];
    
    [self waitForExpectationsWithTimeout:5
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
    self.success(resource);
    
    [_expectation fulfill];
}

- (void)request:(ALMResourceRequest *)request didFetchResources:(RLMResults *)resources task:(NSURLSessionDataTask *)task {
    NSLog(@"didFetchResources: %@", resources);
    XCTAssertNotNil(resources);
    XCTAssertNotEqual(resources.count, 0);
    self.success(resources);
    
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

- (BOOL)request:(ALMResourceRequest *)request commit:(Class)resourceClass data:(NSDictionary *)data inRealm:(RLMRealm *)realm {
    return NO;
}


@end
