//
//  ALMCareer.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSocialResource.h"

@class ALMAcademicUnity;

@interface ALMCareer : ALMSocialResource

@property NSString *name;
@property NSString *url;
@property ALMAcademicUnity *academicUnity;
@property NSString *information;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@end
RLM_ARRAY_TYPE(ALMCareer)