//
//  ALMTeacher.h
//  AlmappCore
//
//  Created by Patricio López on 19-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSocialResource.h"

@interface ALMTeacher : ALMSocialResource

@property NSString *name;
@property NSString *email;
@property NSString *url;
@property NSString *information;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@property (readonly) NSArray *academicUnities;
@property (readonly) NSArray *sections;

@end
RLM_ARRAY_TYPE(ALMTeacher)