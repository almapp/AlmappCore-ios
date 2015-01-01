//
//  ALMPlace.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMPlace.h"

@implementation ALMPlace

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:@"id"]: @"resourceID",
             [self jatt:@"name"]: @"name",
             [self jatt:@"identifier"]: @"identifier",
             [self jatt:@"service"]: @"isService",
             [self jatt:@"zoom"]: @"zoom",
             [self jatt:@"angle"]: @"angle",
             [self jatt:@"tilt"]: @"tilt",
             [self jatt:@"latitude"]: @"latitude",
             [self jatt:@"longitude"]: @"longitude",
             [self jatt:@"floor"]: @"floor",
             [self jatt:@"information"]: @"information"
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"name": @"",
             @"information": @"",
             @"isService": @NO,
             @"floor": @"?",
             @"zoom" : @0.0f,
             @"tilt" : @0.0f,
             @"angle" : @0.0f,
             @"latitude" : @0.0f,
             @"longitude" : @0.0f
             };
}

- (NSArray *)areas {
    return [self linkingObjectsOfClass:@"ALMArea" forProperty:@"places"];
}

//+ (NSValueTransformer *)nameJSONTransformer {
//    return [MCJSONNonNullStringTransformer valueTransformer];
//}

@end