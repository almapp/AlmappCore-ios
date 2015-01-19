//
//  ALMPost.h
//  AlmappCore
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#include "ALMSocialResource.h"
#import "ALMMapable.h"

@protocol ALMPostTargetable, ALMPostPublisher;

@class ALMUser, ALMPlace, ALMEvent;

@interface ALMPost : ALMSocialResource <ALMMapable>

@property ALMUser *user;
@property ALMEvent *event;

@property NSString *content;
@property BOOL shouldNotify;
@property BOOL isHidden;

@property NSString *entityType;
@property long long entityID;
@property NSString *targetType;
@property long long targetID;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (void)setEntity:(ALMResource<ALMPostPublisher>*)entity;
- (ALMResource<ALMPostPublisher>*)entity;

- (void)setTarget:(ALMResource<ALMPostTargetable>*)target;
- (ALMResource<ALMPostTargetable>*)target;

@end
RLM_ARRAY_TYPE(ALMPost)