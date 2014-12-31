//
//  ALMUser.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMUser.h"
#import "RLMObject+JSON.h"
#import "MCJSONNonNullStringTransformer.h"

@implementation ALMUser

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"user.id": @"resourceID",
             @"user.name": @"name",
             @"user.username": @"username",
             @"user.email": @"email",
             @"user.male": @"male"
             };
}


+ (NSString *)primaryKey {
    return @"resourceID";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"name": @"ASD"
             };
}

//+ (NSValueTransformer *)nameJSONTransformer {
//    return [MCJSONNonNullStringTransformer valueTransformer];
//}

@end
