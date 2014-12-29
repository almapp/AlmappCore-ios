//
//  MCJSONNonNullStringTransformer.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "MCJSONNonNullStringTransformer.h"

@implementation MCJSONNonNullStringTransformer

+ (instancetype)valueTransformer
{
    return [[self alloc] init];
}


+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    
    if(value && ![value isKindOfClass:[NSNull class]]) {
        return value;
    } else {
        return @"";
    }
}

- (id)reverseTransformedValue:(id)value
{
    return value;
}

@end
