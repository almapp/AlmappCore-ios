//
//  APITests.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMTestsConstants.h"
#import "ALMUser.h"
#import "ALMCampus.h"
#import "AlmappCore.h"
#import "ALMPlace.h"
#import "ALMAreasController.h"

#import <Realm/Realm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import <AFNetworking/AFNetworking.h>
#import "ALMUsersController.h"
#import "ALMDummyCoreDelegated.h"
#import "ALMFaculty.h"

@interface APITests : XCTestCase
@property (nonatomic, strong) ALMCore *core;
@end

@implementation APITests

- (void)setUp {
    [super setUp];
    _core = [ALMCore initInstanceWithDelegate:[[ALMDummyCoreDelegated alloc] init] baseURL:[NSURL URLWithString:ALMBaseURL]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [_core dropDatabaseInMemory];
    [_core dropDatabaseDefault];
}

- (void)resourceForClass:(Class)rClass resourceID:(NSUInteger)resourceID path:(NSString*)path params:(id)params {
    [self resourceForClass:rClass resourceID:resourceID path:path params:params withController:[ALMController class]];
}

- (void)resourceForClass:(Class)rClass resourceID:(NSUInteger)resourceID path:(NSString*)path params:(id)params withController:(Class)controllerClass {
    XCTestExpectation *singleResourceExpectation = [self expectationWithDescription:[NSString stringWithFormat:@"validSingle_%@", rClass]];
    
    ALMController* controller = [ALMCore controller:controllerClass];
    controller.saveToPersistenceStore = NO;
    AFHTTPRequestOperation *op1 = [controller resourceForClass:rClass inPath:path id:resourceID parameters:params onSuccess:^(id result) {
        [singleResourceExpectation fulfill];
        
        ALMResource *resource = result;
        NSLog(@"Resource Class: %@ | result: %@", rClass, resource);
        XCTAssertNotNil(resource, @"Must not return nil from a valid request");

    } onFailure:^(NSError *error) {
        [singleResourceExpectation fulfill];
        
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [op1 cancel];
    }];
}

- (void)resourcesForClass:(Class)rClass path:(NSString*)path params:(id)params {
    [self resourcesForClass:rClass path:path params:params withController:[ALMController class]];
}

- (void)resourcesForClass:(Class)rClass path:(NSString*)path params:(id)params withController:(Class)controllerClass {
    XCTestExpectation *multipleResourcesExpectation = [self expectationWithDescription:[NSString stringWithFormat:@"validCollection_%@", rClass]];
    
    ALMController* controller = [ALMCore controller:controllerClass];
    controller.saveToPersistenceStore = NO;
    AFHTTPRequestOperation* op2 = [controller resourceCollectionForClass:rClass inPath:path parameters:params onSuccess:^(NSArray *result) {
        [multipleResourcesExpectation fulfill];
        
        NSLog(@"result: %@", result);
        XCTAssertNotNil(result, @"Must rerturn a collection.");
        XCTAssertTrue(result.count != 0, @"Must contain at least one value");
    } onFailure:^(NSError *error) {
        [multipleResourcesExpectation fulfill];
        
        NSLog(@"Error: %@", error);
        XCTFail(@"Error performing request.");
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        [op2 cancel];
    }];
}

- (void)testNilControllerClass {
    XCTAssertNil([ALMCore controller:nil], @"Must return nill for invalid input");
}

- (void)testInvalidClassRequest {
    ALMController* controller = [ALMCore controller];
    AFHTTPRequestOperation *op = [controller resourceForClass:[NSString class] id:1 parameters:nil onSuccess:^(id result) {
        XCTFail(@"This not should be executed");
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
        XCTAssertNotNil(error, @"Must return an error");
    }];
    XCTAssertNil(op, @"Should not return an operation for invalid class input");
    
    op = [controller resourceCollectionForClass:[NSString class] parameters:nil onSuccess:^(NSArray *result) {
        XCTFail(@"This not should be executed");
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
        XCTAssertNotNil(error, @"Must return an error");
    }];
    XCTAssertNil(op, @"Should not return an operation for invalid class input");
}

- (void)testPlaces {
    [self resourceForClass:[ALMPlace class] resourceID:60 path:nil params:nil];
    [self resourcesForClass:[ALMPlace class] path:@"campuses/2/places" params:nil];
}

- (void)testCampuses {
    RLMRealm *realm = [[ALMCore sharedInstance] requestTemporalRealm];
    
    // Has localization
    [self resourceForClass:[ALMCampus class] resourceID:1 path:nil params:nil withController:[ALMAreasController class]];
    ALMCampus *campus = [ALMCampus objectInRealm:realm forPrimaryKey:@1];
    NSLog(@"%@", campus.localization);
    XCTAssertNotNil(campus.localization, @"must have localization");
    NSLog(@"%@", campus.localization.area);
    XCTAssertNotNil(campus.localization.area, @"must have owner");
    NSLog(@"Campus.id = %ld | Campus.localization.area.id = %ld", (long)campus.resourceID, (long)campus.localization.area.resourceID);
    XCTAssertTrue(campus.localization.area.resourceID == campus.resourceID, @"Must be related");

    // Has not localization
    [self resourceForClass:[ALMCampus class] resourceID:6 path:nil params:nil withController:[ALMAreasController class]];
    campus = [ALMCampus objectInRealm:realm forPrimaryKey:@6];
    NSLog(@"%@", campus.localization);
    XCTAssertNil(campus.localization, @"must not have localization");

    
    [self resourcesForClass:[ALMCampus class] path:nil params:nil withController:[ALMAreasController class]];
    
    RLMResults* a = [ALMCampus allObjectsInRealm:realm];
    for(int i = 0 ; i < a.count; i++) {
        ALMCampus *c = [a objectAtIndex:i];
        NSLog(@"Index: %d: %@", i, c.name);
        if(c.localization != nil) {
            NSLog(@"Localization: %@", c.localization.name);
            XCTAssertTrue(c.localization.area.resourceID == c.resourceID, @"Must be related");
        }
    }
}

- (void)testFaculties {
    RLMRealm *realm = [[ALMCore sharedInstance] requestTemporalRealm];
    
    // Has localization
    [self resourceForClass:[ALMFaculty class] resourceID:1 path:nil params:nil withController:[ALMAreasController class]];
    ALMFaculty *faculty = [ALMFaculty objectInRealm:realm forPrimaryKey:@1];
    NSLog(@"%@", faculty.localization);
    XCTAssertNotNil(faculty.localization, @"must have localization");
    NSLog(@"%@", faculty.localization.area);
    XCTAssertNotNil(faculty.localization.area, @"must have owner");
    NSLog(@"faculty.id = %ld | faculty.localization.area.id = %ld", (long)faculty.resourceID, (long)faculty.localization.area.resourceID);
    XCTAssertTrue(faculty.localization.area.resourceID == faculty.resourceID, @"Must be related");
    
    /*
    // Has not localization
    [self resourceForClass:[ALMFaculty class] resourceID:6 path:nil params:nil withController:[ALMAreasController class]];
    faculty = [ALMFaculty objectInRealm:realm forPrimaryKey:@6];
    NSLog(@"%@", faculty.localization);
    XCTAssertNil(faculty.localization, @"must not have localization");
    */
    
    [self resourcesForClass:[ALMFaculty class] path:nil params:nil withController:[ALMAreasController class]];
    
    RLMResults* a = [ALMFaculty allObjectsInRealm:realm];
    for(int i = 0 ; i < a.count; i++) {
        ALMFaculty *c = [a objectAtIndex:i];
        NSLog(@"Index: %d: %@", i, c.name);
        if(c.localization != nil) {
            NSLog(@"Localization: %@", c.localization.name);
            XCTAssertTrue(c.localization.area.resourceID == c.resourceID, @"Must be related");
        }
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
