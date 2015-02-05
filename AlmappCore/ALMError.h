//
//  ALMError.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ALMErrorCode) {
    ALMErrorCodeInvalidRequest,
    ALMErrorCodeNestedRequestFail
};

@interface ALMError : NSError

+ (instancetype)errorWithCode:(ALMErrorCode)code;

@end
