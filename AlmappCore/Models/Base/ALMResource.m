//
//  ALMResource.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"

@implementation ALMResource

+ (NSString*)pluralForm {
    return [self.singleForm stringByAppendingString:@"s"];
}

+ (NSString*)singleForm {
    NSString *className = NSStringFromClass([self class]);
    return [[className stringByReplacingOccurrencesOfString:@"ALM" withString:@""] lowercaseString];
}

+ (NSString *)primaryKey {
    return @"resourceID";
}

+ (NSString *)jsonRoot {
    return self.singleForm;
}

+ (NSString*)jatt:(NSString*)attribute {
    return [self.jsonRoot stringByAppendingString:attribute];
}

@end
