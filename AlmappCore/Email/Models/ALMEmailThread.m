//
//  ALMEmailThread.m
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailThread.h"
#import "ALMEmailConstants.h"
#import "ALMResourceConstants.h"

@implementation ALMEmailThread

+ (NSDictionary *)defaultPropertyValues {
    return @{kEmailIdentifier : kRDefaultNullString,
             kEmailSnippet : kRDefaultNullString};
}

+ (NSString *)primaryKey {
    return kEmailIdentifier;
}


+ (RLMResults *)sortedThreads {
    return [self sortedThreadsInRealm:[RLMRealm defaultRealm]];
}

+ (RLMResults *)sortedThreadsInRealm:(RLMRealm *)realm {
    return [self threadsSortedAscending:NO realm:realm];
}


+ (ALMEmailThread *)newestThread {
    return [self newestThreadInRealm:[RLMRealm defaultRealm]];
}

+ (ALMEmailThread *)newestThreadInRealm:(RLMRealm *)realm {
    return [self threadsSortedAscending:YES realm:realm].firstObject;
}


+ (ALMEmailThread *)oldestThread {
    return [self oldestThreadInRealm:[RLMRealm defaultRealm]];
}

+ (ALMEmailThread *)oldestThreadInRealm:(RLMRealm *)realm {
    return [self threadsSortedAscending:NO realm:realm].firstObject;
}


+ (NSArray *)threadsSortedAscending:(BOOL)ascending first:(NSUInteger)count {
    return [self threadsSortedAscending:ascending realm:[RLMRealm defaultRealm] first:count];
}

+ (NSArray *)threadsSortedAscending:(BOOL)ascending realm:(RLMRealm *)realm first:(NSUInteger)count {
    return [[self threadsSortedAscending:ascending] subarrayLast:count];
}


+ (RLMResults *)threadsSortedAscending:(BOOL)ascending {
    return [self threadsSortedAscending:ascending realm:[RLMRealm defaultRealm]];
}

+ (RLMResults *)threadsSortedAscending:(BOOL)ascending realm:(RLMRealm *)realm {
    return [[self allObjectsInRealm:realm] sortedResultsUsingProperty:kEmailIdentifier ascending:ascending];
}



- (RLMResults *)sortedEmails {
    return [self emailsSortedAscending:NO];
}

- (ALMEmail *)newestEmail {
    return [self emailsSortedAscending:YES].firstObject;
}

- (ALMEmail *)oldetsEmail {
    return [self emailsSortedAscending:NO].firstObject;
}

- (NSArray *)emailsSortedAscending:(BOOL)ascending first:(NSUInteger)count {
    return [[self emailsSortedAscending:ascending] subarrayLast:count];
}

- (RLMResults *)emailsSortedAscending:(BOOL)ascending {
    return [self.emails sortedResultsUsingProperty:kEmailIdentifier ascending:ascending];
}

- (void)deleteEmailsForced:(BOOL)force {
    for (NSInteger i = self.emails.count - 1; i >= 0; i--) {
        [self deleteEmail:self.emails[i] force:force];
    }
}

- (void)deleteEmail:(ALMEmail *)email force:(BOOL)force {
    if (force || email.threads.count <= 1) {
        NSInteger i = [self.emails indexOfObject:email];
        [self.emails removeObjectAtIndex:i];
        [self.realm deleteObject:email];
    }
}

@end
