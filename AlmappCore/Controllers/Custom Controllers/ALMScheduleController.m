//
//  ALMScheduleController.m
//  AlmappCore
//
//  Created by Patricio López on 08-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMScheduleController.h"
#import "ALMCore.h"
#import "ALMResourceConstants.h"

@implementation PMKPromise (InstaSuccess)

+ (PMKPromise *)instaSuccess {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        return;
    }];
}

@end

@interface ALMScheduleController ()

@end

@implementation ALMScheduleController

+ (instancetype)controllerForSession:(ALMSession *)session {
    return [self controllerForSession:session year:[ALMCore currentAcademicYear] period:[ALMCore currentAcademicPeriod]];
}

+ (instancetype)controllerForSession:(ALMSession *)session year:(short)year period:(short)period {
    ALMScheduleController *controller = [[ALMScheduleController alloc] initWithSession:session];
    controller.year = year;
    controller.period = period;
    return controller;
}

- (PMKPromise *)promiseScheduleModulesLoaded {
    if (!self.didLoadScheduleModules) {
        return [self.controller GETResources:[ALMScheduleModule class] parameters:nil];
    }
    else {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
            fulfiller([ALMScheduleModule allObjectsInRealm:self.realm]);
        }];
    }
}

- (PMKPromise *)promiseSectionsLoaded {
    return [self.controller GET:@"me/sections" parameters:nil].then( ^(id JSONArray, NSURLSessionDataTask *task) {
        RLMRealm *realm = self.realm;
        [realm beginWriteTransaction];
        NSArray *sections = [ALMSection createOrUpdateInRealm:realm withJSONArray:JSONArray];
        [self.user hasMany:sections];
        [realm commitWriteTransaction];
        
        return sections;
    });
}

- (PMKPromise *)promiseCoursesLoaded {
    NSDictionary *params = @{kAYear : @(self.year), kAPeriod : @(self.period)};
    return [self.controller GET:@"me/courses" parameters:params].then( ^(id JSONArray, NSURLSessionDataTask *task) {
        RLMRealm *realm = self.realm;
        [realm beginWriteTransaction];
        NSArray *courses = [ALMCourse createOrUpdateInRealm:realm withJSONArray:JSONArray];
        [self.user hasMany:courses];
        [realm commitWriteTransaction];
        
        return courses;
    });
}



- (PMKPromise *)promiseLoaded {
    if (self.shouldUpdate) {
        return [self promiseScheduleModulesLoaded].then( ^{
            return [self promiseCoursesLoaded];
        }).then(^(NSArray *courses, NSURLSessionDataTask *task) {
            return [self promiseSectionsLoaded];
        }).then(^(NSArray *sections, NSURLSessionDataTask *task) {
            return sections;
        });
    }
    else {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
            fulfiller(self.sections);
        }];
    }
}

- (NSArray *)scheduleItemsAtDay:(ALMScheduleDay)day {
    NSMutableArray *temp = [NSMutableArray array];
    for (ALMSection *section in self.sections) {
        id ewe = [section scheduleItemsInDay:day];
        for (ALMScheduleItem *item in ewe) {
            [temp addObject:item];
        }
    }
    return [temp sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(ALMScheduleItem *)a scheduleModule].startTime;
        NSDate *second = [(ALMScheduleItem *)b scheduleModule].startTime;
        return [first compare:second];
    }];
}

- (BOOL)shouldUpdate {
    if (!self.didLoadScheduleModules) {
        return YES;
    }
    if (self.sections.count == 0) {
        return YES;
    }
    if (self.courses.count == 0) {
        return YES;
    }
    return YES; //TODO HEY!
}

- (NSObject<RLMCollection,NSFastEnumeration> *)sections {
    return [self.user sectionsInYear:self.year period:self.period];
}

- (NSObject<RLMCollection,NSFastEnumeration> *)courses {
    return [self.user coursesInYear:self.year period:self.period];
}

- (NSObject<RLMCollection,NSFastEnumeration> *)teachers {
    return [self.user teachersInYear:self.year period:self.period];
}

- (BOOL)didLoadScheduleModules {
    return self.allScheduleModules.count > 0;
}

- (RLMResults *)allScheduleModules {
    return [ALMScheduleModule allObjectsInRealm:self.realm];
}


@end
