//
//  ALMResource.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMResourceConstants.h"

@implementation NSDictionary (ALMResource)

+ (NSDictionary *)merge:(NSDictionary *)dictionary1 with:(NSDictionary *)dictionary2 {
    NSMutableDictionary* total = [NSMutableDictionary dictionaryWithDictionary:dictionary1];
    [total addEntriesFromDictionary: dictionary2];
    return total;
}

@end

@implementation NSString (ALMResource)

- (NSString *)pluralize {
    NSString* singleForm = self;
    char lastChar = [singleForm characterAtIndex:singleForm.length - 1];
    if (lastChar == 'y' || lastChar == 'Y') {
        singleForm = [singleForm substringToIndex: (singleForm.length - 1)];
        return [singleForm stringByAppendingString:@"ies"];
    }
    else {
        return [singleForm stringByAppendingString:@"s"];
    }
}

@end

@implementation ALMResource

+ (NSString*)apiSingleForm {
    return [self singleForm];
}

+ (NSString*)apiPluralForm {
    return [[self apiSingleForm] pluralize];
}

+ (NSString*)realmSingleForm {
    return [self singleForm];
}

+ (NSString*)realmPluralForm {
    return [[self realmSingleForm] pluralize];
}

+ (NSString*)pluralForm {
    return [[self singleForm] pluralize];
}

+ (NSString*)singleForm {
    return [[[self className] stringByReplacingOccurrencesOfString:@"ALM" withString:@""] lowercaseString];
}

+ (NSString *)primaryKey {
    return kRResourceID;
}

+ (NSString *)jsonRoot {
    return [self apiSingleForm];
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

+ (NSString*)jatt:(NSString*)attribute {
    return [NSString stringWithFormat:@"%@.%@", [self jsonRoot], attribute];
}

+ (id)objectInRealm:(RLMRealm *)realm ofType:(Class)resourceClass withID:(NSUInteger)resourceID {
    return [resourceClass performSelector:@selector(objectInRealm:forPrimaryKey:) withObject:realm withObject:[NSNumber numberWithUnsignedLong:resourceID]];
}

@end
