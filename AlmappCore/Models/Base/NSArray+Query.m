//
//  NSArray+Query.m
//  AlmappCore
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "NSArray+Query.h"

@implementation NSArray (Query)

- (NSString *)toRealmStringArray {
    NSString *query = [[self valueForKey:@"description"] componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"{ %@ }", query];
}

@end
