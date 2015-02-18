//
//  ALMUser.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMPostPublisher.h"
#import "ALMSection.h"
#import "ALMCourse.h"
#import "ALMCareer.h"
#import "ALMGroup.h"
#import "ALMEvent.h"
#import "ALMChat.h"

@interface ALMUser : ALMResource <ALMPostPublisher>

@property NSString *name;
@property NSString *username;
@property NSString *email;
@property NSString *studentID;
@property NSString *country;
@property NSString *imageMediumPath;
@property NSString *imageThumbPath;
@property BOOL isFindeable;
@property BOOL isMale;
@property NSDate *lastSignIn;
@property NSDate *currentSignIn;

@property RLMArray<ALMChat> *chats;
@property RLMArray<ALMSection> *sections;
@property RLMArray<ALMCourse> *courses;
@property RLMArray<ALMCareer> *careers;
@property RLMArray<ALMGroup> *subscribedGroups;
@property RLMArray<ALMEvent> *attendingEvents;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (RLMResults *)sectionsInYear:(short)year period:(short)period;
- (RLMResults *)coursesInYear:(short)year period:(short)period;
- (RLMResults *)teachersInYear:(short)year period:(short)period;

@end
RLM_ARRAY_TYPE(ALMUser)