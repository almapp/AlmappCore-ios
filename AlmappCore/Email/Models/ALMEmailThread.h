//
//  ALMEmailThread.h
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmail.h"

@interface ALMEmailThread : RLMObject

@property NSString *threadID;
@property NSString *snippet;
@property RLMArray<ALMEmail> *emails;

@property (readonly) NSArray *folders;
@property (readonly) ALMEmail *newestEmail;
@property (readonly) ALMEmail *oldetsEmail;
@property (readonly) RLMResults *sortedEmails;

- (RLMResults *)emailsSortedAscending:(BOOL)ascending;
- (NSArray *)emailsSortedAscending:(BOOL)ascending first:(NSUInteger)count;

- (void)deleteEmail:(ALMEmail *)email force:(BOOL)force;
- (void)deleteEmailsForced:(BOOL)force;

@end
RLM_ARRAY_TYPE(ALMEmailThread)
