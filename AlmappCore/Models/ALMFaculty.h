//
//  ALMFaculty.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMArea.h"
#import "ALMAcademicUnity.h"

@class ALMCampus;

@interface ALMFaculty : ALMArea

@property RLMArray<ALMAcademicUnity> *academicUnities;
@property ALMCampus *campus;

@end
RLM_ARRAY_TYPE(ALMFaculty)