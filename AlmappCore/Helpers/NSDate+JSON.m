//
//  NSDate+JSON.m
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "NSDate+JSON.h"

@implementation NSDate (JSON)

- (NSString *)JSON {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    return [dateFormat stringFromDate:self];
}

@end
