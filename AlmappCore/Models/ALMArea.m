//
//  ALMArea.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMArea.h"

@implementation ALMArea

+ (NSDictionary *)JSONInboundMappingDictionary {
    NSDictionary* common = @{
             [self jatt:@"id"]: @"resourceID",
             [self jatt:@"name"]: @"name",
             [self jatt:@"short_name"]: @"shortName",
             [self jatt:@"abbreviation"]: @"abbreviation",
             [self jatt:@"address"]: @"address",
             [self jatt:@"email"]: @"email",
             [self jatt:@"url"]: @"url",
             [self jatt:@"facebook"]: @"facebookUrl",
             [self jatt:@"twitter"]: @"twitterUrl",
             [self jatt:@"phone"]: @"phoneString",
             [self jatt:@"information"]: @"information"
             };
    NSMutableDictionary* total = [NSMutableDictionary dictionaryWithDictionary:common];
    [total addEntriesFromDictionary: self.additionalAttributes];
    return total;
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"address": @"",
             @"email": @"",
             @"url": @"",
             @"facebookUrl": @"",
             @"twitterUrl": @"",
             @"phoneString": @"",
             @"information": @""
             };
}

- (NSString *)areaClassType {
    return [NSString stringWithFormat:@"%@", [self class]];
}

+ (NSDictionary *)additionalAttributes {
    return [NSDictionary dictionary];
}

@end
