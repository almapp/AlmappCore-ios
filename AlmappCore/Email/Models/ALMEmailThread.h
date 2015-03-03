//
//  ALMEmailThread.h
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmail.h"

@interface ALMEmailThread : RLMObject

@property NSString *identifier;
@property NSString *snippet;
@property RLMArray<ALMEmail> *emails;

@property (readonly) ALMEmail *newestEmail;
@property (readonly) ALMEmail *oldetsEmail;
@property (readonly) RLMResults *sortedEmails;

+ (RLMResults *)sortedThreads;
+ (RLMResults *)sortedThreadsInRealm:(RLMRealm *)realm;

+ (ALMEmailThread *)newestThread;
+ (ALMEmailThread *)newestThreadInRealm:(RLMRealm *)realm;

+ (ALMEmailThread *)oldestThread;
+ (ALMEmailThread *)oldestThreadInRealm:(RLMRealm *)realm;

+ (NSArray *)threadsSortedAscending:(BOOL)ascending first:(NSUInteger)count;
+ (NSArray *)threadsSortedAscending:(BOOL)ascending realm:(RLMRealm *)realm first:(NSUInteger)count;

+ (RLMResults *)threadsSortedAscending:(BOOL)ascending;
+ (RLMResults *)threadsSortedAscending:(BOOL)ascending realm:(RLMRealm *)realm;

- (RLMResults *)emailsSortedAscending:(BOOL)ascending;
- (NSArray *)emailsSortedAscending:(BOOL)ascending first:(NSUInteger)count;

- (void)deleteEmail:(ALMEmail *)email force:(BOOL)force;
- (void)deleteEmailsForced:(BOOL)force;

@end
RLM_ARRAY_TYPE(ALMEmailThread)
