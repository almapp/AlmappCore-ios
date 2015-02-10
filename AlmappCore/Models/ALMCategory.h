//
//  ALMCategory.h
//  AlmappCore
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"

typedef NS_ENUM(NSInteger, ALMCategoryType) {
    ALMCategoryTypeNone = 0,
    ALMCategoryTypeClassroom,
    ALMCategoryTypeArea,
    ALMCategoryTypeBathMen,
    ALMCategoryTypeBathWomen,
    ALMCategoryTypeTrash,
    ALMCategoryTypeParkBicycle,
    ALMCategoryTypeParkCar,
    ALMCategoryTypeStudy,
    ALMCategoryTypeFoodLunch,
    ALMCategoryTypeFoodStand,
    ALMCategoryTypeFoodMachine,
    ALMCategoryTypePrinter,
    ALMCategoryTypeComputers,
    ALMCategoryTypePhotocopy,
    ALMCategoryTypeCashMachine,
    ALMCategoryTypeBank,
    ALMCategoryTypeLibrary,
    ALMCategoryTypeOther
};

@interface ALMCategory : RLMObject

@property ALMCategoryType category;

@end
RLM_ARRAY_TYPE(ALMCategory)