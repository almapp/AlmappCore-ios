//
//  ALMChat.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMChatMessage.h"

@protocol ALMUser;

@interface ALMChat : ALMResource

@property NSString *title;
@property RLMArray<ALMChatMessage> *chatMessages;
@property RLMArray<ALMUser> *users;
@property NSString *conversableType;
@property long long conversableID;
@property BOOL isAvailable;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (void)setConversable:(ALMResource *)conversable;
- (ALMResource *)conversable;

@end
RLM_ARRAY_TYPE(ALMChat)