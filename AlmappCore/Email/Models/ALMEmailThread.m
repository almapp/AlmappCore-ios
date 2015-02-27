//
//  ALMEmailThread.m
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailThread.h"
#import "ALMEmailFolder.h"

@implementation ALMEmailThread

+ (NSDictionary *)defaultPropertyValues {
    return @{@"threadID" : @"",
             @"snippet" : @""};
}

+ (NSString *)primaryKey {
    return @"threadID";
}

- (NSArray *)folders {
    return [self linkingObjectsOfClass:[ALMEmailFolder className] forProperty:@"threads"];
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
    return [self.emails sortedResultsUsingProperty:@"messageID" ascending:ascending];
}

- (void)deleteEmailsForced:(BOOL)force {
    for (NSUInteger i = 0; i < self.emails.count; i++) {
        [self deleteEmail:self.emails[i] force:force];
    }
}

- (void)deleteEmail:(ALMEmail *)email force:(BOOL)force {
    if (force || email.threads.count <= 1) {
        NSUInteger i = [self.emails indexOfObject:email];
        [self.emails removeObjectAtIndex:i];
        [email removeFromRealm];
    }
}

@end
