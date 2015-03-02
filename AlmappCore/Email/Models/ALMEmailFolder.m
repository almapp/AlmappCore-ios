//
//  ALMEmailLabel.m
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailFolder.h"
#import "ALMEmailConstants.h"
#import "ALMResourceConstants.h"

@implementation ALMEmailFolder

+ (NSDictionary *)defaultPropertyValues {
    return @{kRIdentifier : kRDefaultNullString};
}

+ (NSString *)primaryKey {
    return kRIdentifier;
}

- (RLMResults *)sortedThreads {
    return [self threadsSortedAscending:NO];
}

- (ALMEmailThread *)newestThread {
    return [self threadsSortedAscending:YES].firstObject;
}

- (ALMEmailThread *)oldestThread {
    return [self threadsSortedAscending:NO].firstObject;
}

- (NSArray *)threadsSortedAscending:(BOOL)ascending first:(NSUInteger)count {
    return [[self threadsSortedAscending:ascending] subarrayLast:count];
}

- (RLMResults *)threadsSortedAscending:(BOOL)ascending {
    return [self.threads sortedResultsUsingProperty:kEmailIdentifier ascending:ascending];
}

- (void)deleteThreadsForced:(BOOL)force {
    for (NSInteger i = self.threads.count - 1; i >= 0; i--) {
        [self deleteThread:self.threads[i] force:force];
    }
}

- (void)deleteThread:(ALMEmailThread *)thread force:(BOOL)force {
    if (force || thread.folders.count <= 1) {
        NSInteger i = [self.threads indexOfObject:thread];
        [self.threads removeObjectAtIndex:i];
        [thread deleteEmailsForced:NO];
        [self.realm deleteObject:thread];
    }
}


@end
