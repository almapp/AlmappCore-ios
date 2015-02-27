//
//  ALMEmail.m
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmail.h"

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

@end
