//
//  ALMSection.h
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSocialResource.h"
#import "ALMTeacher.h"
#import "ALMScheduleItem.h"

@class ALMCourse;
@protocol ALMUser;

@interface ALMSection : ALMSocialResource

@property NSString *identifier;
@property int vacancy;
@property int number;
@property int year;
@property int period;
@property ALMCourse *course;
@property RLMArray<ALMScheduleItem> *scheduleItems;
@property RLMArray<ALMUser> *students;
@property RLMArray<ALMTeacher> *teachers;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (RLMResults *)scheduleItemsInDay:(ALMScheduleDay)day;

@end
RLM_ARRAY_TYPE(ALMSection)