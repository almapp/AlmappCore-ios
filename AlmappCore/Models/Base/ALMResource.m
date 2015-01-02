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
    return [NSString stringWithFormat:@"%@.%@", self.jsonRoot, attribute];
}

+ (id)objectInRealm:(RLMRealm *)realm ofType:(Class)resourceClass withID:(NSUInteger)resourceID {
    return [resourceClass performSelector:@selector(objectInRealm:forPrimaryKey:) withObject:realm withObject:[NSNumber numberWithUnsignedLong:resourceID]];
}

@end
