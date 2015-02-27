//
//  ALMEmailLabel.m
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailLabel.h"

@implementation ALMEmailLabel

+ (NSDictionary *)defaultPropertyValues {
    return @{@"identifier" : @""};
}

+ (NSString *)primaryKey {
    return @"identifier";
}

@end
