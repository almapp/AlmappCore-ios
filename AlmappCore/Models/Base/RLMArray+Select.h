//
//  RLMArray+Select.h
//  AlmappCore
//
//  Created by Patricio López on 08-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "RLMArray.h"

@interface RLMArray (Select)

- (NSArray *)select:(NSString *)column;
- (NSArray *)select:(NSString *)column ascending:(BOOL)ascending;

@end