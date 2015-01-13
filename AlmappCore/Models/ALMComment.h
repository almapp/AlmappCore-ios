//
//  ALMComment.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMLikeable.h"

@class ALMUser;
@protocol ALMCommentable;

@interface ALMComment : ALMResource <ALMLikeable>

@property ALMUser *user;
@property NSString *commentableType;
@property long long commentableID;
@property NSString *comment;
@property BOOL isHidden;
@property BOOL isAnonymous;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (void)setCommentable:(ALMResource<ALMCommentable>*)commmentable;
- (ALMResource<ALMCommentable>*)commentable;

@end
RLM_ARRAY_TYPE(ALMComment)