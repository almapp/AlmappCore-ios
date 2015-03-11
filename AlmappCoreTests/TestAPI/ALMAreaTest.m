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
    return @[/*[ALMOrganization class], [ALMCampus class],*/ [ALMBuilding class], [ALMFaculty class], [ALMAcademicUnity class]];
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

- (void)testCategories {
    RLMRealm *realm =  self.testRealm;
    
    [realm beginWriteTransaction];
    
    ALMCampus *campus = [[ALMCampus alloc] init];
    campus.resourceID = 1;

    ALMPlace *place = [[ALMPlace alloc] init];
    place.resourceID = 1;
    place.identifier = @"place";
    place.area = campus;
    
    [realm addObjects:@[campus, place]];
    
    [campus.places addObject:place];
    
    ALMCategory *category = [[ALMCategory alloc] init];
    category.category = ALMCategoryTypeClassroom;
    
    place = [ALMPlace objectInRealm:realm withID:1];
    [place.categories addObject:category];
    
    [realm commitWriteTransaction];
    
    RLMResults *results = [campus placesWithCategory:ALMCategoryTypeClassroom];
    XCTAssertNotEqual(results.count, 0);
}

- (void)testCategory {
    NSDictionary *data = @{@"category" : @"bath"};
    RLMRealm *realm =  self.testRealm;
    
    [realm beginWriteTransaction];
    id resource = [ALMCategory createOrUpdateInRealm:self.testRealm withJSONDictionary:data];
    XCTAssertNotNil(resource);
    [realm commitWriteTransaction];
    
    
    [self resource:[ALMPlace class] id:1 path:nil params:nil onSuccess:^(ALMPlace *resource) {
        NSLog(@"%@", resource);
        
        XCTAssertNotNil(resource.categories);
        XCTAssertNotEqual(resource.categories.count, 0);
    }];
}

- (void)testPlaces {
    [self resources:[ALMPlace class] path:@"buildings/1/places" params:nil onSuccess:^(RLMResults *resources) {
        NSLog(@"%@", resources);
    }];
}

- (void)testAreasLocalization {
    for (Class areaClass in self.areaSubclasses) {
        [self testAreaLocalization:areaClass id:1];
    }
}

- (void)testNestedPlacesOn:(Class)areaSubclass id:(long long)areaSubclassID {
    [self nestedResources:[ALMPlace class] as:nil on:areaSubclass id:areaSubclassID as:@"area" path:nil params:nil onSuccess:^(id parent, RLMResults *results) {
        NSLog(@"Parent: %@", parent);
        NSLog(@"Collection: %@", results);
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
