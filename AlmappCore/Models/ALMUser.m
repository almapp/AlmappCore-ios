//
//  ALMUser.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMUser.h"

@implementation ALMUser

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:@"id"]: @"resourceID",
             [self jatt:@"name"]: @"name",
             [self jatt:@"username"]: @"username",
             [self jatt:@"email"]: @"email",
             [self jatt:@"male"]: @"male",
             [self jatt:@"student_id"]: @"studentId",
             [self jatt:@"country"]: @"country",
             [self jatt:@"findeable"]: @"findeable",
             [self jatt:@"last_sign_in_at"]: @"lastSeen"
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"name": @"",
             @"male": @YES,
             @"studentId": @"",
             @"country": @"",
             @"findeable": @YES,
             @"lastSeen": [NSDate distantPast]
             };
}

//+ (NSValueTransformer *)nameJSONTransformer {
//    return [MCJSONNonNullStringTransformer valueTransformer];
//}

@end
