//
//  ALMSectionsController.h
//  AlmappCore
//
//  Created by Patricio López on 19-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMController.h"
#import "ALMSection.h"
#import "ALMCourse.h"

@interface ALMSectionsController : ALMController

- (AFHTTPRequestOperation *)sectionsFor:(ALMCourse*)course year:(short)year period:(short)period onSuccess:(void (^)(id course, NSArray *sections))onSuccess onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)sectionsForCourseWithID:(long long)courseID year:(short)year period:(short)period onSuccess:(void (^)(id course, NSArray *sections))onSuccess onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)sectionsInThisPeriodFor:(ALMCourse*)course onSuccess:(void (^)(id course, NSArray *sections))onSuccess onFailure:(void (^)(NSError *error))onFailure;

- (AFHTTPRequestOperation *)sectionsInThisPeriodForCourseWithID:(long long)courseID onSuccess:(void (^)(id course, NSArray *sections))onSuccess onFailure:(void (^)(NSError *error))onFailure;

@end
