//
//  ALMPlace.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMPlace.h"
#import "ALMArea.h"

static NSString *const DEFAULT_AREA_TYPE = @"NONE";

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
             @"areaType": DEFAULT_AREA_TYPE,
             @"areaID": @0,
             @"floor": @"?",
             @"zoom" : @0.0f,
             @"tilt" : @0.0f,
             @"angle" : @0.0f,
             @"latitude" : @0.0f,
             @"longitude" : @0.0f
             };
}

- (void)setArea:(ALMArea *)area {
    [self setAreaID:area.resourceID];
    [self setAreaType:area.areaClassType];
}

- (ALMArea *)area {
    NSLog(@"%@", self.areaType);
    Class areaClass = NSClassFromString(self.areaType);
    
    id key = [NSNumber numberWithInteger:self.areaID];
    return [areaClass performSelector:@selector(objectInRealm:forPrimaryKey:) withObject:[self realm] withObject:key];
}

//+ (NSValueTransformer *)nameJSONTransformer {
//    return [MCJSONNonNullStringTransformer valueTransformer];
//}

@end