//
//  ALMTeacher.h
//  AlmappCore
//
//  Created by Patricio López on 19-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSocialResource.h"

@protocol ALMSection, ALMAcademicUnity;

@interface ALMTeacher : ALMSocialResource

@property NSString *name;
@property NSString *email;
@property NSString *url;
@property NSString *imageMediumPath;
@property NSString *imageThumbPath;
@property RLMArray<ALMAcademicUnity> *academicUnities;
@property RLMArray<ALMSection> *sections;
@property NSString *information;


@property NSDate *updatedAt;
@property NSDate *createdAt;

@end
RLM_ARRAY_TYPE(ALMTeacher)