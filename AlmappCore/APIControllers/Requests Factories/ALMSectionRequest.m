//
//  ALMSectionRequest.m
//  AlmappCore
//
//  Created by Patricio López on 26-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSectionRequest.h"
#import "ALMResourceConstants.h"
#import "ALMCore.h"

@implementation NSDictionary (ALMSectionRequest)

+ (NSDictionary *)merge:(NSDictionary *)dictionary1 with:(NSDictionary *)dictionary2 {
    NSMutableDictionary* total = [NSMutableDictionary dictionaryWithDictionary:dictionary1];
    [total addEntriesFromDictionary: dictionary2];
    return total;
}

@end

@implementation ALMSectionRequest

+ (NSDictionary *)paramsFor:(short)year period:(short)period {
    return @{
             kAYear     : [NSString stringWithFormat:@"%hd", year],
             kAPeriod : [NSString stringWithFormat:@"%hd", period]
             };
}

+ (short)currentYear {
    return [ALMCore currentAcademicYear];
}

+ (short)currentPeriod {
    return [ALMCore currentAcademicPeriod];
}

+ (ALMRequest *)requestCurrentSectionsFor:(ALMCourse *)course request:(ALMNestedCollectionRequest *)request {
    NSDictionary *params = [self paramsFor:self.currentYear period:self.currentPeriod];
    request.parent = course;
    request.resourceClass = [ALMSection class];
    request.parameters = (request.parameters) ? [NSDictionary merge:request.parameters with:params] : params;
    return request;
}

+ (ALMRequest *)requestCurrentSectionsForCourseWithID:(long long)courseID request:(ALMNestedCollectionRequest *)request {
    NSDictionary *params = [self paramsFor:self.currentYear period:self.currentPeriod];
    request.parentClass = [ALMCourse class];
    request.parentID = courseID;
    request.resourceClass = [ALMSection class];
    request.parameters = (request.parameters) ? [NSDictionary merge:request.parameters with:params] : params;
    return request;
}

+ (ALMRequest *)requestSectionsFor:(ALMCourse *)course year:(short)year period:(short)period request:(ALMNestedCollectionRequest *)request {
    NSDictionary *params = [self paramsFor:year period:period];
    request.parent = course;
    request.resourceClass = [ALMSection class];
    request.parameters = (request.parameters) ? [NSDictionary merge:request.parameters with:params] : params;
    return request;
}

+ (ALMRequest *)requestSectionsForCourseWithID:(long long)courseID year:(short)year period:(short)period request:(ALMNestedCollectionRequest *)request {
    NSDictionary *params = [self paramsFor:year period:period];
    request.parentClass = [ALMCourse class];
    request.parentID = courseID;
    request.resourceClass = [ALMSection class];
    request.parameters = (request.parameters) ? [NSDictionary merge:request.parameters with:params] : params;
    return request;
}

@end
