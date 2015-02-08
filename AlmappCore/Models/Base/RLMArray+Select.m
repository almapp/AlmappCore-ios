//
//  RLMArray+Select.m
//  AlmappCore
//
//  Created by Patricio López on 08-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "RLMArray+Select.h"
#import "RLMResults+Select.h"
#import <Realm+JSON/RLMObject+JSON.h>

@implementation RLMArray (Select)

- (NSArray *)select:(NSString *)column {
    //return [self valueForKeyPath:column];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    SEL selector = NSSelectorFromString(column);
    
    for (RLMObject *resource in self) {
        if([resource respondsToSelector:selector]) {
            id ewe = [resource valueForKey:column];
            [array addObject:ewe];
        }
    }
    return array;
}

- (NSArray *)select:(NSString *)column ascending:(BOOL)ascending {
    RLMResults *sorted = [self sortedResultsUsingProperty:column ascending:ascending];
    return [sorted select:column];
}

@end