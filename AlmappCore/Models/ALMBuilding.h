//
//  ALMBuilding.h
//  AlmappCore
//
//  Created by Patricio López on 11-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMArea.h"

@class ALMCampus;

@interface ALMBuilding : ALMArea

@property ALMCampus *campus;

@end
RLM_ARRAY_TYPE(ALMBuilding)