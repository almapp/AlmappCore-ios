//
//  ALMCategory.m
//  AlmappCore
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCategory.h"
#import "ALMResourceConstants.h"

@implementation ALMCategory

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{kACategory : kRCategory};
}

+ (NSString *)primaryKey {
    return kRCategory;
}

+ (NSDictionary *)defaultPropertyValues {
    return @{kRCategory : kRDefaultNullString};
}

@end
