//
//  ALMAreaTest.m
//  AlmappCore
//
//  Created by Patricio López on 24-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourceTest.h"

@interface ALMAreaTest : ALMResourceTest

@end

@implementation ALMAreaTest

- (NSArray*)areaSubclasses {
    return @[/*[ALMOrganization class],*/ [ALMCampus class], [ALMBuilding class], [ALMFaculty class], [ALMAcademicUnity class]];
}

- (void)testAreaRequests {
    for (Class areaClass in self.areaSubclasses) {
        [self resources:areaClass path:nil params:nil onSuccess:^(RLMResults *resources) {
            XCTAssertNotNil(resources, @"Must rerturn a collection.");
            XCTAssertNotEqual(resources.count, 0, @"Must contain at least one value.");
            XCTAssertTrue([resources.firstObject isKindOfClass:areaClass], @"Fetched area incorrect type.");
        }];
    }
}

- (void)testNestedPlaces {
    for (Class areaClass in self.areaSubclasses) {
        [self testNestedPlacesOn:areaClass id:1];
    }
}

- (void)testAreasLocalization {
    for (Class areaClass in self.areaSubclasses) {
        [self testAreaLocalization:areaClass id:1];
    }
}

- (void)testNestedPlacesOn:(Class)areaSubclass id:(long long)areaSubclassID {
    [self nestedResources:[ALMPlace class] on:[ALMCampus class] id:2 path:nil params:nil onSuccess:^(id parent, RLMArray *results) {
        
    }];
}


- (void)nestedResources:(Class)resourcesClass
                     on:(Class)parentClass
                     id:(long long)parentID
                   path:(NSString *)path
                 params:(id)params
              onSuccess:(void (^)(id parent, RLMArray *results))onSuccess {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"validGetMultipleResource"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMNestedCollectionRequest request:^(ALMNestedCollectionRequest *builder) {
        builder.realm = weakSelf.testRealm;
        builder.parentClass = parentClass;
        builder.parentID = parentID;
        builder.resourceClass = resourcesClass;
        
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
    }];
}


- (void)testAreaLocalization:(Class)areaSubclass id:(long long)areaSubclassID {
    [self resource:areaSubclass id:areaSubclassID path:nil params:nil onSuccess:^(id resource) {
        XCTAssertNotNil(resource, @"Must rerturn a valid object of type %@", areaSubclass);
        XCTAssertTrue([resource isKindOfClass:areaSubclass], @"Fetched area incorrect type.");
        
        XCTAssertNotNil(((ALMArea*)resource).localization, @"Should have a localization");
    }];
}

@end
