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

@implementation NSData (Convertion)

- (NSDictionary *)toDictionary {
    return (self.length > 0) ? [NSKeyedUnarchiver unarchiveObjectWithData:self] : @{};
}

@end

@implementation NSDictionary (Convertion)

- (NSData *)toData {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end

@implementation ALMEmail

+ (NSDictionary *)defaultPropertyValues {
    return @{kEmailIdentifier : kRDefaultNullString,
             kEmailSubject : kRDefaultNullString,
             @"toData" : [NSData data],
             @"fromData" : [NSData data],
             @"ccData" : [NSData data],
             @"ccoData" : [NSData data],
             kEmailSnippet : kRDefaultNullString,
             kEmailLabels : @(kEmailDefaultLabel),
             kEmailBodyHTML : kRDefaultNullString,
             kEmailBodyPlain : kRDefaultNullString,
             kEmailDate : [NSDate date]
             };
}

+ (NSString *)primaryKey {
    return kEmailIdentifier;
}

- (NSArray *)threads {
    return [self linkingObjectsOfClass:[ALMEmailThread className] forProperty:@"emails"];
}

+ (instancetype)createWithIdentifier:(NSString *)identifier {
    ALMEmail *email = [[ALMEmail alloc] init];
    email.identifier = identifier;
    return email;
}

- (NSDictionary *)from {
    return self.fromData.toDictionary;
}

- (NSDictionary *)to {
    return self.toData.toDictionary;
}

- (NSDictionary *)cc {
    return self.ccData.toDictionary;
}

- (NSDictionary *)cco {
    return self.ccoData.toDictionary;
}

- (void)setFrom:(NSDictionary *)values {
    self.fromData = (values) ? values.toData : [NSData data];
}

- (void)setTo:(NSDictionary *)values {
    self.toData = (values) ? values.toData : [NSData data];
}

- (void)setCc:(NSDictionary *)values {
    self.ccData = (values) ? values.toData : [NSData data];
}

- (void)setCco:(NSDictionary *)values {
    self.ccoData = (values) ? values.toData : [NSData data];
}


+ (BOOL)validateEmailAddress:(NSString *)email {
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:emailRegEx
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error != nil)
        return NO;
    
    NSRange stringRange = NSMakeRange(0, email.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:email options:0 range:stringRange];
    
    return NSEqualRanges(matchRange, stringRange);
}

@end
