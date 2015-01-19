//
//  ALMSection.h
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSocialResource.h"
#import "ALMUser.h"

@class ALMCourse;

@interface ALMSection : ALMSocialResource

@property int number;
@property int year;
@property int period;
@property RLMArray<ALMUser> *students;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@property (readonly) ALMCourse *course;

@end
RLM_ARRAY_TYPE(ALMSection)