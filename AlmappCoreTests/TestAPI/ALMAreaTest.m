//
//  ALMAreaTest.m
//  AlmappCore
//
//  Created by Patricio López on 24-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourceTest2.h"

@interface ALMAreaTest : ALMResourceTest2

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

- (void)testAreaLocalization:(Class)areaSubclass id:(long long)areaSubclassID {
    [self resource:areaSubclass id:areaSubclassID path:nil params:nil onSuccess:^(id resource) {
        XCTAssertNotNil(resource, @"Must rerturn a valid object of type %@", areaSubclass);
        XCTAssertTrue([resource isKindOfClass:areaSubclass], @"Fetched area incorrect type.");
        
        XCTAssertNotNil(((ALMArea*)resource).localization, @"Should have a localization");
    }];
}

@end
