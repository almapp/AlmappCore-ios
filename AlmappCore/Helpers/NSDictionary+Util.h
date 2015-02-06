//
//  NSDictionary+Merge.h
//  AlmappCore
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Util)

- (NSDictionary *)merge:(NSDictionary *)dictionary;
- (NSDictionary *)invert;

@end
