//
//  ALMEmail.m
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmail.h"
#import "ALMEmailThread.h"
#import "ALMEmailConstants.h"
#import "ALMResourceConstants.h"

ALMEmailLabel const kEmailDefaultLabel = 0;

@implementation ALMEmail

+ (NSDictionary *)defaultPropertyValues {
    return @{kEmailMessageID : kRDefaultNullString,
             kEmailSubject : kRDefaultNullString,
             kEmailTo : kRDefaultNullString,
             kEmailFrom : kRDefaultNullString,
             kEmailReplyTo : kRDefaultNullString,
             //@"toName" : @"",
             //@"toEmail" : @"",
             //@"fromName" : @"",
             //@"fromEmail" : @"",
             //@"replyToName" : @"",
             //@"replyToEmail" : @"",
             kEmailSnippet : kRDefaultNullString,
             kEmailLabels : @(kEmailDefaultLabel),
             kEmailBodyHTML : kRDefaultNullString,
             kEmailBodyPlain : kRDefaultNullString,
             kEmailDate : [NSDate date]
             };
}

+ (NSString *)primaryKey {
    return kEmailMessageID;
}

- (NSArray *)threads {
    return [self linkingObjectsOfClass:[ALMEmailThread className] forProperty:@"emails"];
}

@end
