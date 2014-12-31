//
//  ALMCampus.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "RLMObject.h"

@interface ALMCampus : RLMObject

@property NSInteger resourceID;
@property NSString *name;
@property NSString *shortName;
@property NSString *abbreviation;
@property NSString *address;
@property NSString *email;
@property NSString *url;
@property NSString *facebookUrl;
@property NSString *twitterUrl;
@property NSString *phoneString;
@property NSString *information;
//@property NSDate *updatedAt;
//@property NSDate *createdAt;

@end
RLM_ARRAY_TYPE(ALMCampus)