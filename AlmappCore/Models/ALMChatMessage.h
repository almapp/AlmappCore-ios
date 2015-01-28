//
//  ALMChatMessage.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"

@class ALMUser, ALMChat;

@interface ALMChatMessage : ALMResource

@property ALMUser *user;
@property ALMChat *chat;
@property NSString *content;
@property BOOL isFlagged;
@property BOOL isHidden;

@property NSDate *updatedAt;
@property NSDate *createdAt;

@end
RLM_ARRAY_TYPE(ALMChatMessage)