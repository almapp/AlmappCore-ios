//
//  ALMResource.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMResourceConstants.h"

ALMPersistMode const kPersistModeDefault = ALMPersistModeMuchAsPosible;

#pragma mark - Dictionary Category

@implementation NSDictionary (ALMResource)

+ (NSDictionary *)merge:(NSDictionary *)dictionary1 with:(NSDictionary *)dictionary2 {
    NSMutableDictionary* total = [NSMutableDictionary dictionaryWithDictionary:dictionary1];
    [total addEntriesFromDictionary: dictionary2];
    return total;
}

@end

#pragma mark - String Category

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

#pragma mark - Resource body

@implementation ALMResource

- (NSString *)className {
    return NSStringFromClass([self class]);
}

#pragma mark - Attributes helpers

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

#pragma mark - JSON helpers

+ (NSString *)primaryKey {
    return kRResourceID;
}

+ (NSString *)jsonRoot {
    return [self apiSingleForm];
}

+ (NSString*)jatt:(NSString*)attribute {
    return [NSString stringWithFormat:@"%@.%@", [self jsonRoot], attribute];
}

#pragma mark - Persistence

+ (ALMPersistMode)persistMode {
    return kPersistModeDefault;
}

+ (id)objectInRealm:(RLMRealm *)realm ofType:(Class)resourceClass withID:(long long)resourceID {
    return [resourceClass performSelector:@selector(objectInRealm:forPrimaryKey:) withObject:realm withObject:[NSNumber numberWithLongLong:resourceID]];
}

+ (id)objectOfType:(Class)resourceClass withID:(long long)resourceID {
    return [self objectInRealm:[RLMRealm defaultRealm] ofType:resourceClass withID:resourceID];
}

@end
