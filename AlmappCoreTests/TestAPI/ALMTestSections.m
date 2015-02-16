//
//  ALMTestSections.m
//  AlmappCore
//
//  Created by Patricio López on 26-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ALMResourceTest.h"

@interface ALMTestSections : ALMResourceTest

@end

@implementation ALMTestSections

- (void)testSection {
    [self nestedResources:[ALMSection class] as:nil on:[ALMCourse class] id:1 as:nil path:nil params:nil onSuccess:^(id parent, RLMResults *results) {
        for (ALMSection *section in results) {
            XCTAssertNotNil(section.course);
        }
    }];
}

- (void)testScheduleController {
    NSString *description = [NSString stringWithFormat:@"GET: %@", @"schedule"];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    __block ALMSession *session = self.testSession;
    
    ALMScheduleController *controller = [ALMScheduleController controllerForSession:session year:2015 period:1];
    
    XCTAssertNotNil(controller.user);
    
    [controller promiseLoaded].then( ^(RLMResults *sections) {
        NSLog(@"%@", sections);
        
        XCTAssertNotEqual(session.user.sections.count, 0);
        XCTAssertNotEqual(session.user.courses.count, 0);
        
        XCTAssertEqual(session.user.sections.count, controller.sections.count);
        XCTAssertEqual(session.user.courses.count, controller.courses.count);
        
        XCTAssertNotEqual(controller.teachers.count, 0);
        
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)testUserSchedule {
    /*
    NSString *description = [NSString stringWithFormat:@"GET: %@", @"schedule"];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    __weak typeof(self) weakSelf = self;
    
    [self.controller FETCH:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *builder) {
        builder.resourceClass = [ALMScheduleModule class];
        builder.realmPath = [weakSelf testRealmPath];
        builder.shouldLog = YES;
        builder.credential = [weakSelf testSession].credential;
        
    } onLoad:^(id result) {
        NSLog(@"Loaded: %@", result);
        
    } onFetch:^(id result, NSURLSessionDataTask *task) {
        [weakSelf.controller FETCH:[ALMResourceRequestBlock request:^(ALMResourceRequestBlock *r) {
            r.resourceClass = [ALMSection class];
            r.realmPath = [weakSelf testRealmPath];
            r.customPath = @"me/sections";
            r.shouldLog = YES;
            r.credential = [weakSelf testSession].credential;
            
        } onLoad:^(id result) {
            
        } onFetch:^(id result, NSURLSessionDataTask *task) {
            ALMUser *user = [self testSession].user;
            [user hasMany:result];
            
            for (ALMSection *section in result) {
                for (int i = ALMScheduleDayMonday; i <= ALMScheduleDaySunday; i++) {
                    RLMResults *inDay = [section scheduleItemsInDay:i];
                    NSLog(@"%@", inDay);
                    for (ALMScheduleItem *item in inDay) {
                        XCTAssertEqual(item.scheduleModule.day, i);
                    }
                }
            }
            
            RLMResults *sections = [user sectionsInYear:2014 period:1];
            XCTAssertEqual(sections.count, 0, @"Must be empty for old period");
            
            sections = [user sectionsInYear:2015 period:1];
            XCTAssertNotEqual(sections.count, 0);
            
            RLMResults *teachers = [user teachersInYear:2015 period:1];
            XCTAssertNotEqual(teachers.count, 0);
            
            [expectation fulfill];
            
        } onError:^(NSError *error, NSURLSessionDataTask *task) {
            
        }]];
        
    } onError:[self errorBlock:expectation class:[ALMScheduleModule class]]]];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        NSLog(@"%@", error);
    }];
     */
}

- (void)testSectionCourse {
    [self resource:[ALMSection class] id:2365 path:nil params:nil onSuccess:^(ALMSection* resource) {
        XCTAssertNotNil(resource.course);
    }];
    /*
    XCTestExpectation *expectation = [self expectationWithDescription:@"validGetSingleResource"];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *op = [self.requestManager GET:[ALMSingleRequest request:^(ALMSingleRequest *builder) {
        builder.realm = weakSelf.testRealm;
        builder.resourceClass = [ALMSection class];
        builder.resourceID =  1;
        
    } onLoad:^(ALMSection *loadedResource) {
        
    } onFinish:^(NSURLSessionDataTask *task, ALMSection *loadedResource) {
        XCTAssertNotNil(loadedResource);
        [expectation fulfill];
        
    } onError:[self errorBlock:expectation class:[ALMSection class]]]];
    
     [self waitForExpectationsWithTimeout:self.timeout handler:^(NSError *error) {
        [op cancel];
    }];
*/
}

@end
