//
//  NSDictionary+Merge.m
//  AlmappCore
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "NSDictionary+Util.h"

@implementation NSDictionary (Util)

- (NSDictionary *)merge:(NSDictionary *)dictionary {
    NSMutableDictionary* total = [self mutableCopy];
    [total addEntriesFromDictionary: dictionary];
    return total;
}

- (NSDictionary *)invert {
    NSMutableDictionary *new = [NSMutableDictionary dictionaryWithCapacity:self.count];
    
    for (NSString *key in [self allKeys]) {
        new[self[key]] = key;
    }
    return new;
}

@end

