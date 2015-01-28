//
//  ALMGroup.h
//  AlmappCore
//
//  Created by Patricio López on 15-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMSocialResource.h"
#import "ALMPostPublisher.h"
#import "ALMPostTargetable.h"

@protocol ALMUser;

@interface ALMGroup : ALMSocialResource <ALMPostTargetable, ALMPostPublisher>

@property NSString *name;
@property NSString *email;
@property NSString *url;
@property RLMArray<ALMUser> *subscribers;
@property NSString *facebookUrl;
@property NSString *twitterUrl;
@property NSString *information;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@end
RLM_ARRAY_TYPE(ALMGroup)