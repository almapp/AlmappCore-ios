//
//  ALMResourcesTests.h
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ALMTestCase.h"

@interface ALMResourcesTests : ALMTestCase

- (NSTimeInterval)timeout;

- (void(^)(id, NSArray*))defaultNestedSuccessBlock;
- (void(^)(id))defaultSingleSuccessBlock;
- (void(^)(NSArray*))defaultCollectionSuccessBlock;

- (ALMController*)getController:(Class)controllerClass;

- (void)testNameMatching:(NSDictionary*)expectedMatches;

- (void)testClass:(Class)classToTest match:(NSString*)name;

- (void)testClasses:(NSArray*)classesToTest math:(NSArray*)names;

- (void)resource:(Class)rClass
              ID:(NSUInteger)resourceID
            path:(NSString*)path
          params:(id)params
    afterSuccess:(void (^)(id result))afterSuccess;

- (void)resource:(Class)rClass
              ID:(NSUInteger)resourceID
            path:(NSString*)path
          params:(id)params
  withController:(Class)controllerClass
    afterSuccess:(void (^)(id result))afterSuccess;

- (void)resourceCollection:(Class)rClass
                      path:(NSString*)path
                    params:(id)params
              afterSuccess:(void (^)(NSArray *result))afterSuccess;

- (void)resourceCollection:(Class)rClass
                      path:(NSString*)path
                    params:(id)params
            withController:(Class)controllerClass
              afterSuccess:(void (^)(NSArray *result))afterSuccess;

- (void)nestedResourceCollection:(Class)rClass
                              on:(Class)parentClass
                          withID:(long long)parentID
                          params:(id)params
                  withController:(Class)controllerClass
                    afterSuccess:(void (^)(id parent, NSArray *result))afterSuccess;

- (void)nestedResourceCollection:(Class)rClass
                              on:(Class)parentClass
                          withID:(long long)parentID
                          params:(id)params
                    afterSuccess:(void (^)(id parent, NSArray *result))afterSuccess;

@end
