//
//  ALMCampus.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMCampus.h"
#import "RLMObject+JSON.h"
#import "MCJSONNonNullStringTransformer.h"

@implementation ALMCampus

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"campus.id": @"resourceID",
             @"campus.name": @"name",
             @"campus.short_name": @"shortName",
             @"campus.abbreviation": @"abbreviation",
             @"campus.address": @"address",
             @"campus.email": @"email",
             @"campus.url": @"url",
             @"campus.facebook": @"facebookUrl",
             @"campus.twitter": @"twitterUrl",
             @"campus.phone": @"phoneString",
             @"campus.information": @"information"
             };
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

+ (NSString *)pluralForm {
    return @"campuses";
}

@end
