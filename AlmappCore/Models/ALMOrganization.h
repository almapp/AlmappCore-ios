//
//  ALMOrganization.h
//  AlmappCore
//
//  Created by Patricio López on 02-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMArea.h"
#import "ALMCampus.h"
#import "ALMFaculty.h"
#import "ALMAcademicUnity.h"

@interface ALMOrganization : ALMArea

@property RLMArray<ALMCampus> *campuses;
@property RLMArray<ALMFaculty> *faculties;
@property RLMArray<ALMBuilding> *buildings;
@property RLMArray<ALMAcademicUnity> * academicUnities;

@end
RLM_ARRAY_TYPE(ALMOrganization)
