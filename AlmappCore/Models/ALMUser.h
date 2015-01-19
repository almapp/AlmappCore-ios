//
//  ALMUser.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMPostPublisher.h"

@interface ALMUser : ALMResource <ALMPostPublisher>

@property NSString *name;
@property NSString *username;
@property NSString *email;
@property NSString *studentID;
@property NSString *country;
@property BOOL isFindeable;
@property BOOL isMale;
@property NSDate *lastSeen;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@property (readonly) NSArray *sections;
@property (readonly) NSArray *subscribedGroups;
@property (readonly) NSArray *attendingEvents;

@end
RLM_ARRAY_TYPE(ALMUser)