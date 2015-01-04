//
//  ALMCareer.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMCommentable.h"
#import "ALMLikeable.h"

@class ALMAcademicUnity;

@interface ALMCareer : ALMResource <ALMLikeable, ALMCommentable>

@property NSString *name;
@property NSString *url;
@property NSString *curriculumUrl;
@property ALMAcademicUnity *academicUnity;
@property NSString *information;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@end
RLM_ARRAY_TYPE(ALMCareer)