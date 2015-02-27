//
//  ALMEmailLabel.h
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailThread.h"

@interface ALMEmailFolder : RLMObject

@property NSString *identifier;
@property RLMArray<ALMEmailThread> *threads;

@property (readonly) ALMEmailThread *newestThread;
@property (readonly) ALMEmailThread *oldestThread;
@property (readonly) RLMResults *sortedThreads;

- (RLMResults *)threadsSortedAscending:(BOOL)ascending;
- (NSArray *)threadsSortedAscending:(BOOL)ascending first:(NSUInteger)count;

- (void)deleteThread:(ALMEmailThread *)thread force:(BOOL)force;
- (void)deleteThreadsForced:(BOOL)force;

@end
RLM_ARRAY_TYPE(ALMEmailFolder)
