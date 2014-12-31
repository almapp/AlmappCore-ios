//
//  MCJSONNonNullStringTransformer.h
//  From: https://github.com/matthewcheok/Realm-JSON/issues/12
//  Author: https://github.com/johanforssell
//

#import <Foundation/Foundation.h>

@interface MCJSONNonNullStringTransformer : NSValueTransformer
+ (instancetype)valueTransformer;
@end
