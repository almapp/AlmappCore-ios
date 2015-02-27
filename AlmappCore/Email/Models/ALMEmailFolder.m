//
//  ALMEmailLabel.m
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailFolder.h"

@implementation ALMEmailFolder

+ (NSDictionary *)defaultPropertyValues {
    return @{@"identifier" : @""};
}

+ (NSString *)primaryKey {
    return @"identifier";
}

- (NSArray *)threadsSortedAscending:(BOOL)ascending first:(NSUInteger)count {
    return [[self threadsSortedAscending:ascending] subarrayLast:count];
}

- (RLMResults *)threadsSortedAscending:(BOOL)ascending {
    return [self.threads sortedResultsUsingProperty:@"threadID" ascending:ascending];
}

- (void)deleteThreadsForced:(BOOL)force {
    for (NSUInteger i = 0; i < self.threads.count; i++) {
        [self deleteThread:self.threads[i] force:force];
    }
}

- (void)deleteThread:(ALMEmailThread *)thread force:(BOOL)force {
    if (force || thread.folders.count <= 1) {
        NSUInteger i = [self.threads indexOfObject:thread];
        [self.threads removeObjectAtIndex:i];
        [thread deleteEmailsForced:NO];
        [thread removeFromRealm];
    }
}


@end
