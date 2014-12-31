//
//  MCJSONNonNullStringTransformer.m
//  From: https://github.com/matthewcheok/Realm-JSON/issues/12
//  Author: https://github.com/johanforssell
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
