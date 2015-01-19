//
//  ALMSectionsController.m
//  AlmappCore
//
//  Created by Patricio López on 19-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSectionsController.h"
#import "ALMResourceConstants.h"
#import "ALMCore.h"

@implementation ALMSectionsController

+ (NSDictionary *)paramsFor:(short)year period:(short)period {
    return @{
             kAYear     : [NSString stringWithFormat:@"%hd", year],
             kAPeriod : [NSString stringWithFormat:@"%hd", period]
             };
}

- (AFHTTPRequestOperation *)sectionsFor:(ALMCourse *)course year:(short)year period:(short)period onSuccess:(void (^)(id, NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    return [self nestedResourceCollection:[ALMSection class] nestedOn:course parameters:[self.class paramsFor:year period:period] onSuccess:onSuccess onFailure:onFailure];
}

- (AFHTTPRequestOperation *)sectionsForCourseWithID:(long long)courseID year:(short)year period:(short)period onSuccess:(void (^)(id, NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    ALMCourse *course = [ALMCourse objectInRealm:self.requestRealm forID:courseID];
    if (course) {
        return [self sectionsFor:course year:year period:period onSuccess:onSuccess onFailure:onFailure];
    }
    else {
        return [self nestedResourceCollection:[ALMSection class] nestedOn:[ALMCourse class] withID:courseID parameters:[self.class paramsFor:year period:period] onSuccess:onSuccess onFailure:onFailure];
    }
}

- (AFHTTPRequestOperation *)sectionsInThisPeriodFor:(ALMCourse *)course onSuccess:(void (^)(id, NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    short year = [ALMCore currentAcademicYear];
    short period = [ALMCore currentAcademicPeriod];
    return [self sectionsFor:course year:year period:period onSuccess:onSuccess onFailure:onFailure];
}

- (AFHTTPRequestOperation *)sectionsInThisPeriodForCourseWithID:(long long)courseID onSuccess:(void (^)(id, NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    short year = [ALMCore currentAcademicYear];
    short period = [ALMCore currentAcademicPeriod];
    return [self sectionsForCourseWithID:courseID year:year period:period onSuccess:onSuccess onFailure:onFailure];
}

@end
