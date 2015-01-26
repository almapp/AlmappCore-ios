//
//  ALMScheduleItem.h
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMScheduleModule.h"

@class ALMSection, ALMPlace, ALMCampus;

@interface ALMScheduleItem : ALMResource

@property long long scheduleModuleID;
@property NSString *classType;
@property NSString *placeName;
@property NSString *campusName;
@property long long placeID;
@property long long campusID;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@property (readonly) ALMSection *section;
@property (readonly) ALMScheduleModule *scheduleModule;
@property (readonly) ALMPlace *place;
@property (readonly) ALMCampus *campus;

@end
RLM_ARRAY_TYPE(ALMScheduleItem)