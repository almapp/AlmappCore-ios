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


+ (NSString *)primaryKey {
    return @"resourceID";
}

+ (NSValueTransformer *)patoJSONTransformer {
    return [MCJSONNonNullStringTransformer valueTransformer];
}

+ (NSValueTransformer *)addressJSONTransformer {
    return [MCJSONNonNullStringTransformer valueTransformer];
}

+ (NSValueTransformer *)emailJSONTransformer {
    return [MCJSONNonNullStringTransformer valueTransformer];
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [MCJSONNonNullStringTransformer valueTransformer];
}
+ (NSValueTransformer *)facebookUrlJSONTransformer {
    return [MCJSONNonNullStringTransformer valueTransformer];
}
+ (NSValueTransformer *)twitterUrlJSONTransformer {
    return [MCJSONNonNullStringTransformer valueTransformer];
}
+ (NSValueTransformer *)informationJSONTransformer {
    return [MCJSONNonNullStringTransformer valueTransformer];
}
@end
