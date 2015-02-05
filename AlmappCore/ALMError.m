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
    switch (code) {
        case ALMErrorCodeInvalidRequest:
            return [self errorWithDomain:@"Controller" code:code userInfo:@{NSLocalizedDescriptionKey : @"Invalid request"}];
            
        case ALMErrorCodeNestedRequestFail:
            return [self errorWithDomain:@"Controller" code:ALMErrorCodeNestedRequestFail userInfo:@{NSLocalizedDescriptionKey : @"Could not fetch parent and nested resources"}];
            
        default:
            return [self errorWithDomain:@"AlmappCore" code:ALMErrorCodeNestedRequestFail userInfo:@{NSLocalizedDescriptionKey : @"Some bad has happend"}];
    }
}

@end
