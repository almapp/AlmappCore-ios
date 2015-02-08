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

@property (strong, nonatomic) ALMUser *user;
@property (strong, nonatomic) ALMCredential *credential;

@end

@implementation ALMScheduleController

+ (instancetype)scheduleForSession:(ALMSession *)session year:(short)year period:(short)period {
    return [self scheduleFor:session.user withCredential:session.credential year:year period:period];
}

+ (instancetype)scheduleFor:(ALMUser *)user withCredential:(ALMCredential *)credential year:(short)year period:(short)period {
    ALMScheduleController *controller = [[ALMScheduleController alloc] init];
    controller.year = year;
    controller.period = period;
    controller.user = user;
    controller.credential = credential;
    return controller;
}

- (ALMController *)controller {
    return [ALMCore controller];
}

- (PMKPromise *)promiseScheduleModulesLoaded {
    if (!self.didLoadScheduleModules) {
        return [self.controller GET:[ALMResourceRequest request:^(ALMResourceRequest *r) {
            r.credential = self.credential;
            r.resourceClass = [ALMScheduleModule class];
            r.realmPath = self.user.realm.path;
            
        } delegate:nil]];
    }
    else {
        return [PMKPromise instaSuccess];
    }
}

- (PMKPromise *)promiseSectionsLoaded {
    __weak __typeof(self) weakSelf = self;
    return [self.controller GET:[ALMResourceRequest request:^(ALMResourceRequest *r) {
        r.credential = weakSelf.credential;
        r.resourceClass = [ALMSection class];
        r.realmPath = weakSelf.user.realm.path;
        r.customPath = @"me/sections";
        r.parameters =  @{kAYear : @(weakSelf.year),
                          kAPeriod : @(weakSelf.period)};;
        
    } delegate:nil]];
}

- (PMKPromise *)promiseCoursesLoaded {
    __weak __typeof(self) weakSelf = self;
    return [self.controller GET:[ALMResourceRequest request:^(ALMResourceRequest *r) {
        r.credential = weakSelf.credential;
        r.resourceClass = [ALMCourse class];
        r.realmPath = weakSelf.user.realm.path;
        r.customPath = @"me/courses";
        r.parameters =  @{kAYear : @(weakSelf.year),
                          kAPeriod : @(weakSelf.period)};;
        
    } delegate:nil]];
}



- (PMKPromise *)promiseLoaded {
    PMKPromise *promise = nil;
    if (self.shouldUpdate) {
        __weak __typeof(self) weakSelf = self;
        [self promiseScheduleModulesLoaded].then(^ {
            return [weakSelf promiseSectionsLoaded];
        }).then(^(RLMResults *sections, NSURLSessionDataTask *task) {
            [weakSelf.user hasMany:sections];
            return sections;
        });
    }
    else {
        promise = [PMKPromise instaSuccess];
    }
    
    return promise;
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
    if (self.courses == 0) {
        return YES;
    }
    return NO;
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
    return [ALMScheduleModule allObjectsInRealm:self.user.realm];
}


@end
