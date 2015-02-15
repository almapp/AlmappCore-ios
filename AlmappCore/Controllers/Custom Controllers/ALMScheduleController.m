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
    return [ALMCore controllerWithCredential:self.credential];
}

- (PMKPromise *)promiseScheduleModulesLoaded {
    if (!self.didLoadScheduleModules) {
        return [self.controller GETResources:[ALMScheduleModule class] parameters:nil].then(^(id responseObject, NSURLSessionDataTask *task){
            return [ALMScheduleModule createOrUpdateInRealm:self.realm withJSONArray:responseObject];
        });
    }
    else {
        return [PMKPromise instaSuccess];
    }
}

- (PMKPromise *)promiseSectionsLoaded {
    return [self.controller GET:@"me/sections" parameters:nil].then(^(id responseObject, NSURLSessionDataTask *task){
        return [ALMSection createOrUpdateInRealm:self.realm withJSONArray:responseObject];
    });
}

- (PMKPromise *)promiseCoursesLoaded {
    NSDictionary *params = @{kAYear : @(self.year), kAPeriod : @(self.period)};
    return [self.controller GET:@"me/courses" parameters:params].then(^(id responseObject, NSURLSessionDataTask *task){
        return [ALMCourse createOrUpdateInRealm:self.realm withJSONArray:responseObject];
    });
}



- (PMKPromise *)promiseLoaded {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        if (self.shouldUpdate) {
            [self promiseScheduleModulesLoaded].then( ^{
                return [self promiseCoursesLoaded];
            }).then(^(RLMResults *courses, NSURLSessionDataTask *task) {
                [self.user hasMany:courses];
                return [self promiseSectionsLoaded];
            }).then(^(RLMResults *sections, NSURLSessionDataTask *task) {
                [self.user hasMany:sections];
                fulfiller(sections);
            }).catch( ^(NSError *error) {
                NSLog(@"Error %@", error);
                rejecter(error);
            });
        }
        else {
            fulfiller(self.sections);
        }
    }];
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

- (RLMRealm *)realm {
    return self.user.realm;
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
