//
//  ALMError.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMError.h"

@implementation ALMError

+ (instancetype)errorWithCode:(ALMErrorCode)code {
    return [self errorWithDomain:@"ewe" code:code userInfo:nil];
}

@end
