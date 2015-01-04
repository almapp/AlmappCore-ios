//
//  ALMComment.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"

@class ALMUser;

@interface ALMComment : ALMResource

@property ALMUser *user;
@property NSString *commentableType;
@property NSInteger commentableID;
@property NSString *comment;
@property BOOL isHidden;
@property BOOL isAnonymous;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (void)setCommentable:(ALMResource*)commmentable;
- (id)commentable;

@end
RLM_ARRAY_TYPE(ALMComment)