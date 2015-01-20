//
//  ALMResourcesTests.m
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourcesTests.h"

@implementation ALMResourcesTests

- (void (^)(id, NSArray *))defaultNestedSuccessBlock {
    return ^(id parent , NSArray* nestedCollection) {
        XCTAssertNotNil(parent, @"Must rerturn a valid parent object.");
        XCTAssertNotNil(nestedCollection, @"Must rerturn a valid collection.");
        XCTAssertNotEqual(nestedCollection.count, 0, @"Must contain at least one value.");
        
        ALMResource* sample = nestedCollection.firstObject;
        
        SEL collectionSelector = NSSelectorFromString(sample.realmPluralForm);
        
        if ([parent respondsToSelector:collectionSelector]) {
            IMP imp = [parent methodForSelector:collectionSelector];
            RLMArray* (*func)(id, SEL) = (void*)imp;
            RLMArray *parentNestedResourcecollection = func(parent, collectionSelector);
            
            XCTAssertEqual(parentNestedResourcecollection.count, nestedCollection.count, @"Must be coherent nested results");
        }
    };
}

- (void (^)(id))defaultSingleSuccessBlock {
    return ^(id result) {
        XCTAssertNotNil(result, @"Must rerturn a valid parent object.");
    };
}

- (void (^)(NSArray *))defaultCollectionSuccessBlock {
    return ^(NSArray *collection) {
        XCTAssertNotNil(collection, @"Must rerturn a valid collection.");
        XCTAssertNotEqual(collection.count, 0, @"Must contain at least one value.");
    };
}

- (void)testNaming {
    NSDictionary *expectedMatches = @{[ALMResource singleForm] : @"Resource",
                                      [ALMResource pluralForm] : @"Resources",
                                      [ALMResource apiSingleForm] : @"resource",
                                      [ALMResource apiPluralForm] : @"resources",
                                      [ALMResource realmSingleForm] : @"resource",
                                      [ALMResource realmPluralForm] : @"resources"
                                      };
    
    [self testNameMatching:expectedMatches];
}

- (NSTimeInterval)timeout {
    return 5;
}

- (id)getController:(Class)controllerClass {
    ALMController* controller = (controllerClass != NULL && controllerClass != nil) ? [self.core controller:controllerClass] : [self.core controller];
    controller.saveToPersistenceStore = NO;
    return controller;
}

- (void)testNameMatching:(NSDictionary*)expectedMatches {
    for (NSString *name in expectedMatches.allKeys) {
        NSString *expectedValue = [expectedMatches objectForKey:name];
        XCTAssertEqualObjects(name, expectedValue, @"Must match");
    }
}

- (void)testClass:(Class)classToTest match:(NSString*)name {
    NSString* className = [classToTest className];
    XCTAssertTrue([className isEqualToString:name]);
}

- (void)testClasses:(NSArray*)classesToTest match:(NSArray*)names {
    for (int i = 0; i < classesToTest.count; i++) {
        [self testClass:classesToTest[i] match:names[i]];
    }
}

- (void)resource:(Class)rClass
              ID:(NSUInteger)resourceID
            path:(NSString*)path
          params:(id)params
       afterSuccess:(void (^)(id result))afterSuccess {
 
    [self resource:rClass ID:resourceID path:path params:params withController:[ALMController class] afterSuccess:afterSuccess];
}

- (void)resource:(Class)rClass
              ID:(NSUInteger)resourceID
            path:(NSString*)path
          params:(id)params
  withController:(Class)controllerClass
    afterSuccess:(void (^)(id result))afterSuccess {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"%@Single_Expectation", rClass]];
    
    ALMController* controller = [self getController:controllerClass];
    
    ALMResourcesTests * __weak weakSelf = self;
    
    AFHTTPRequestOperation *op = [controller resource:rClass inPath:path id:resourceID parameters:params onSuccess:^(id result) {
        NSLog(@"Resource Class: %@ | result: %@", rClass, result);
        if (afterSuccess != nil) {
            afterSuccess(result);
        } else {
            weakSelf.defaultSingleSuccessBlock(result);
        }
        [expectation fulfill];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Resource Class: %@ | error: %@", rClass, error);
        XCTFail(@"Error performing request.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[self timeout] handler:^(NSError *error) {
        [op cancel];
    }];
}

- (void)resourceCollection:(Class)rClass
                      path:(NSString*)path
                    params:(id)params
              afterSuccess:(void (^)(NSArray *result))afterSuccess {
    
    [self resourceCollection:rClass path:path params:params withController:[ALMController class] afterSuccess:afterSuccess];
}

- (void)resourceCollection:(Class)rClass
                      path:(NSString*)path
                    params:(id)params
            withController:(Class)controllerClass
              afterSuccess:(void (^)(NSArray *result))afterSuccess {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"validCollection_%@", rClass]];
    
    ALMController* controller = [self getController:controllerClass];
    
    ALMResourcesTests * __weak weakSelf = self;
    
    AFHTTPRequestOperation* op = [controller resourceCollection:rClass inPath:path parameters:params onSuccess:^(NSArray *result) {
        
        NSLog(@"Resource Collection: %@ | result: %@", rClass, result);
        if (afterSuccess != nil) {
            afterSuccess(result);
        } else {
            weakSelf.defaultCollectionSuccessBlock(result);
        }
        [expectation fulfill];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Resource Class: %@ | error: %@", rClass, error);
        XCTFail(@"Error performing request.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:[self timeout] handler:^(NSError *error) {
        [op cancel];
    }];
}

- (void)nestedResourceCollection:(Class)rClass
                              on:(Class)parentClass
                          withID:(long long)parentID
                          params:(id)params
                    afterSuccess:(void (^)(id, NSArray *))afterSuccess {
    
    [self nestedResourceCollection:rClass on:parentClass withID:parentID params:params withController:[ALMController class] afterSuccess:afterSuccess];
}

- (void)nestedResourceCollection:(Class)rClass
                              on:(Class)parentClass
                          withID:(long long)parentID
                          params:(id)params
                  withController:(Class)controllerClass
                    afterSuccess:(void (^)(id parent, NSArray *result))afterSuccess {
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"validNestedCollection_%@", rClass]];
    
    ALMController* controller = [self getController:controllerClass];
    
    ALMResourcesTests * __weak weakSelf = self;
    
    AFHTTPRequestOperation* op = [controller nestedResourceCollection:rClass nestedOn:parentClass withID:parentID parameters:params onSuccess:^(id parent, NSArray *result) {
        if (afterSuccess != nil) {
            afterSuccess(parent, result);
        } else {
            weakSelf.defaultNestedSuccessBlock(parent, result);
        }
        [expectation fulfill];
        
    } onFailure:^(NSError *error) {
        NSLog(@"Resource Class: %@ | error: %@", rClass, error);
        XCTFail(@"Error performing request.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [op cancel];
    }];
}



@end
