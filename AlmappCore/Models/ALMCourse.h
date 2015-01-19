//
//  ALMCourse.h
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSocialResource.h"
#import "ALMSection.h"

@class ALMAcademicUnity;

@interface ALMCourse : ALMSocialResource

@property NSString *initials;
@property NSString *name;
@property int credits;
@property BOOL isAvailable;
@property NSString *information;
@property RLMArray<ALMSection> *sections;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@property (readonly) ALMAcademicUnity *academicUnity;

- (RLMResults *)sectionsOnYear:(short)year period:(short)period;

@end
RLM_ARRAY_TYPE(ALMCourse)