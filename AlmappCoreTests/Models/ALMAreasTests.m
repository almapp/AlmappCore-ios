//
//  ALMAreasTests.m
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMResourcesTests.h"

@interface ALMAreasTests : ALMResourcesTests

@end

@implementation ALMAreasTests

- (void)testPlaces {
    [self resource:[ALMPlace class] ID:1 path:nil params:nil afterSuccess:^(NSArray *result) {
        XCTAssertNotNil(result, @"Must rerturn a valid object.");
        XCTAssertTrue([result isKindOfClass:[ALMPlace class]], @"Nested collection incorrect type.");
        
        ALMPlace* place = [ALMPlace objectInRealm:self.testRealm forID:1];
        XCTAssertNotNil(place, @"New object must be able to load.");
    }];
    [self resourceCollection:[ALMPlace class] path:@"campuses/2/places" params:nil afterSuccess:^(NSArray *result) {
        XCTAssertNotNil(result, @"Must rerturn a collection.");
        XCTAssertNotEqual(result.count, 0, @"Must contain at least one value.");
        XCTAssertTrue([result.firstObject isKindOfClass:[ALMPlace class]], @"Nested collection incorrect type.");
    }];
}

- (void)testAreas {
    NSArray *areas = @[[ALMOrganization class], [ALMCampus class], [ALMBuilding class], [ALMFaculty class], [ALMAcademicUnity class]];
    for (Class areaClass in areas) {
        [self testArea:areaClass];
    }
    
    [self testAreas:[ALMFaculty class] nestedOn:[ALMCampus class] withID:1];
    [self testAreas:[ALMAcademicUnity class] nestedOn:[ALMCampus class] withID:1];
    [self testAreas:[ALMBuilding class] nestedOn:[ALMCampus class] withID:1];
}

- (void)testAreas:(Class)areaSubclass nestedOn:(Class)parentAreaClass withID:(long long)parentID {
    [self nestedResourceCollection:areaSubclass on:parentAreaClass withID:parentID params:nil afterSuccess:nil];
}

- (void)testArea:(Class)areaSubclass {
    [self resource:areaSubclass ID:1 path:nil params:nil afterSuccess:^(NSArray *result) {
        XCTAssertNotNil(result, @"Must rerturn a valid object.");
        XCTAssertTrue([result isKindOfClass:areaSubclass], @"Nested collection incorrect type.");
        
        id area = [areaSubclass objectInRealm:self.testRealm forID:1];
        XCTAssertNotNil(area, @"New object must be able to load.");
    }];
    [self resourceCollection:areaSubclass path:nil params:nil afterSuccess:^(NSArray *result) {
        XCTAssertNotNil(result, @"Must rerturn a collection.");
        XCTAssertNotEqual(result.count, 0, @"Must contain at least one value.");
        XCTAssertTrue([result.firstObject isKindOfClass:areaSubclass], @"Nested collection incorrect type.");
    }];
}


@end
