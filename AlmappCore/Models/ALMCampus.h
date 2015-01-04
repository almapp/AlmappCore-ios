//
//  ALMCampus.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMArea.h"
#import "ALMFaculty.h"
#import "ALMAcademicUnity.h"

@class ALMOrganization;

@interface ALMCampus : ALMArea

@property RLMArray<ALMFaculty> *faculties;
@property RLMArray<ALMAcademicUnity> *academicUnities;
@property ALMOrganization *organization;

@end
RLM_ARRAY_TYPE(ALMCampus)