//
//  ALMEmail.m
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmail.h"
#import "ALMEmailThread.h"

@implementation ALMEmail

+ (NSDictionary *)defaultPropertyValues {
    return @{@"messageID" : @"",
             @"subject" : @"",
             @"to" : @"",
             @"from" : @"",
             @"replyTo" : @"",
             //@"toName" : @"",
             //@"toEmail" : @"",
             //@"fromName" : @"",
             //@"fromEmail" : @"",
             //@"replyToName" : @"",
             //@"replyToEmail" : @"",
             @"snippet" : @"",
             @"date" : [NSDate date]
             };
}

+ (NSString *)primaryKey {
    return @"messageID";
}

- (NSArray *)threads {
    return [self linkingObjectsOfClass:[ALMEmailThread className] forProperty:@"emails"];
}

@end
