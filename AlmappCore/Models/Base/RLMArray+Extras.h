//
//  RLMArray+Select.h
//  AlmappCore
//
//  Created by Patricio López on 08-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "RLMArray.h"

@interface RLMArray (Extras)

- (NSArray *)select:(NSString *)column;
- (NSArray *)select:(NSString *)column distinct:(BOOL)distinct;

- (NSArray *)select:(NSString *)column ascending:(BOOL)ascending;
- (NSArray *)select:(NSString *)column ascending:(BOOL)ascending distinct:(BOOL)distinct;

- (NSArray *)addObjects:(id<NSFastEnumeration>)objects allowDuplicates:(BOOL)allowDuplicates;
- (BOOL)addObject:(RLMObject *)object allowDuplicates:(BOOL)allowDuplicates;

- (NSArray *)subarrayFirst:(NSUInteger)items;
- (NSArray *)subarrayLast:(NSUInteger)items;
- (NSArray *)subarrayWithRange:(NSRange)range;

@end