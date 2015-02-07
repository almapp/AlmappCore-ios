//
//  ALMCategory.m
//  AlmappCore
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCategory.h"

@implementation ALMCategory

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{@"category" : @"category"};
}

+ (NSString *)primaryKey {
    return @"category";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"category" : @""};
}

@end
