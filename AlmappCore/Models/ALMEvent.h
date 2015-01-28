//
//  ALMEvent.h
//  AlmappCore
//
//  Created by Patricio López on 03-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMMapable.h"

@protocol ALMEventHost, ALMUser;

@interface ALMEvent : ALMSocialResource <ALMMapable>

@property NSString *title;
@property BOOL isPrivate;
@property NSString *information;
@property NSDate *publishDate;
@property NSDate *fromDate;
@property NSDate *toDate;
@property ALMUser *user;
@property RLMArray<ALMUser> *participants;
@property NSString *hostType;
@property long long hostID;
@property NSString *facebookUrl;
@property NSString *url;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (void)setHost:(ALMResource<ALMEventHost>*)host;
- (ALMResource<ALMEventHost>*)host;

@end
RLM_ARRAY_TYPE(ALMEvent)