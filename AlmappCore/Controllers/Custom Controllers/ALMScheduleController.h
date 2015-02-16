//
//  ALMScheduleController.h
//  AlmappCore
//
//  Created by Patricio López on 08-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMController.h"
#import "ALMUser.h"
#import "ALMCustomController.h"

@interface ALMScheduleController : ALMCustomController

@property (assign) short year;
@property (assign) short period;

@property (readonly) ALMUser *user;

@property (readonly) NSObject<RLMCollection, NSFastEnumeration> *sections;
@property (readonly) NSObject<RLMCollection, NSFastEnumeration> *courses;
@property (readonly) NSObject<RLMCollection, NSFastEnumeration> *teachers;


@property (readonly) PMKPromise *promiseLoaded;
@property (readonly) PMKPromise *promiseScheduleModulesLoaded;
@property (readonly) PMKPromise *promiseSectionsLoaded;
@property (readonly) PMKPromise *promiseCoursesLoaded;

+ (instancetype)controllerForSession:(ALMSession *)session
                                year:(short)year
                              period:(short)period;

- (NSArray *)scheduleItemsAtDay:(ALMScheduleDay)day;

- (BOOL)shouldUpdate;


@end
