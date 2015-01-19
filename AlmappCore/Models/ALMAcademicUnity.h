//
//  ALMAcademicUnity.h
//  AlmappCore
//
//  Created by Patricio López on 03-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMArea.h"
#import "ALMCourse.h"

@class ALMFaculty;

@interface ALMAcademicUnity : ALMArea

@property ALMFaculty* faculty;
@property RLMArray<ALMCourse> *courses;

@end
RLM_ARRAY_TYPE(ALMAcademicUnity)