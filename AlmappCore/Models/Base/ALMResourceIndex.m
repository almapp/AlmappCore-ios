//
//  ALMResourceIndex.m
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceIndex.h"

@interface ALMResourceIndex ()

+ (Class)classNamed:(NSString*)className;

+ (NSString*)posibleClassNameFor:(NSString*)apiName;

@end

@implementation ALMResourceIndex

+ (Class)classWithAPIName:(NSString *)apiName {
    NSString* className;
    
    if ([apiName isEqualToString:@"webpage"]) {
        className = @"ALMWebPage";
    } else {
        className = [self posibleClassNameFor:apiName];
    }
    return [self classNamed:className];
}

+ (Class)classNamed:(NSString *)className {
    return NSClassFromString(className);
}

+ (NSString*)posibleClassNameFor:(NSString *)apiName {
    NSMutableString *result = [NSMutableString string];
    for (NSString *part in [apiName componentsSeparatedByString:@"_"]) {
        [result appendString:[part capitalizedString]];
    }
    
    return [NSString stringWithFormat:@"ALM%@", result];
}



@end
