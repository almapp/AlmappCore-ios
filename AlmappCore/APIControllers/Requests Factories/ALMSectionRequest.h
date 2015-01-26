//
//  ALMSectionRequest.h
//  AlmappCore
//
//  Created by Patricio López on 26-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMNestedCollectionRequest.h"
#import "ALMCourse.h"

@interface ALMSectionRequest : NSObject

+ (ALMRequest *)requestSectionsFor:(ALMCourse *)course
                              year:(short)year
                            period:(short)period
                           request:(ALMNestedCollectionRequest *)request;

+ (ALMRequest *)requestSectionsForCourseWithID:(long long)courseID
                                          year:(short)year
                                        period:(short)period
                                       request:(ALMNestedCollectionRequest *)request;

+ (ALMRequest *)requestCurrentSectionsFor:(ALMCourse *)course
                                  request:(ALMNestedCollectionRequest *)request;

+ (ALMRequest *)requestCurrentSectionsForCourseWithID:(long long)courseID
                                              request:(ALMNestedCollectionRequest *)request;

@end
