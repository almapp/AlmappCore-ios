//
//  ALMEmailThread.m
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailThread.h"

@implementation ALMEmailThread

+ (NSDictionary *)defaultPropertyValues {
    return @{@"threadID" : @"",
             @"snippet" : @""};
}

+ (NSString *)primaryKey {
    return @"threadID";
}

@end
