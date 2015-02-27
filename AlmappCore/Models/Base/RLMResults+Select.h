//
//  RLMResults+Select.h
//  AlmappCore
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "RLMResults.h"

@interface RLMResults (Select)

- (NSArray *)select:(NSString *)column;
- (NSArray *)select:(NSString *)column distinct:(BOOL)distinct;

- (NSArray *)select:(NSString *)column ascending:(BOOL)ascending;
- (NSArray *)select:(NSString *)column ascending:(BOOL)ascending distinct:(BOOL)distinct;

- (NSArray *)subarrayFirst:(NSUInteger)items;
- (NSArray *)subarrayLast:(NSUInteger)items;
- (NSArray *)subarrayWithRange:(NSRange)range;

@end

