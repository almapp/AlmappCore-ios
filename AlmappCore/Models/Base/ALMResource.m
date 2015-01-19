//
//  ALMResource.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMResourceConstants.h"
#import "ALMResourceIndex.h"

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

#pragma mark - Date Category

@implementation NSDate (ALMResource)

+ (NSDate *)defaultDate {
    return [self distantPast];
}

+ (NSDate *)defaultEventDate {
    return [self distantPast];
}

@end

#pragma mark - Resource interface

@interface ALMResource ()

+ (void)append:(NSArray*)newObjects to:(RLMArray*)collection;

@end

#pragma mark - Resource body

@implementation ALMResource

- (NSString *)className {
    return [[self class] className];
}

#pragma mark - Attributes helpers

+ (NSString*)apiSingleForm {
    return [[self singleForm] lowercaseString];
}

+ (NSString*)apiPluralForm {
    return [[self apiSingleForm] pluralize];
}

+ (NSString*)realmSingleForm {
    return [[self singleForm] lowercaseString];
}

+ (NSString*)realmPluralForm {
    return [[self realmSingleForm] pluralize];
}

+ (NSString*)pluralForm {
    return [[self singleForm] pluralize];
}

+ (NSString*)singleForm {
    return [[self className] stringByReplacingOccurrencesOfString:@"ALM" withString:@""];
}

- (NSString*)apiSingleForm {
    return [[self class] apiSingleForm];
}

- (NSString*)apiPluralForm {
    return [[self class] apiPluralForm];
}

- (NSString*)realmSingleForm {
    return [[self class] realmSingleForm];
}

- (NSString*)realmPluralForm {
    return [[self class] realmPluralForm];
}

- (NSString*)pluralForm {
    return [[self class] pluralForm];
}

- (NSString*)singleForm {
    return [[self class] singleForm];
}

#pragma mark - JSON helpers

+ (NSString *)primaryKey {
    return kRResourceID;
}

+ (NSString *)jsonRoot {
    return [self apiSingleForm];
}

- (NSString *)jsonRoot {
    return [[self class] jsonRoot];
}

+ (NSString*)jatt:(NSString*)attribute {
    return [NSString stringWithFormat:@"%@.%@", [self jsonRoot], attribute];
}

/*
+ (NSString*)jatts:(NSString*)attributes, ... {
    NSMutableString * res = [NSMutableString stringWithString:[self jsonRoot]];
    [res appendString:attributes];
    
    va_list args;
    va_start(args, attributes);
    id arg = nil;
    
    while(( arg = va_arg(args, id))){
        [res appendString:@"."];
        [res appendString:arg];
    }
    va_end(args);
    return res;
}
 */

#pragma mark - Methods

+ (NSDictionary *)JSONNestedResourceInboundMappingDictionary {
    return @{};
}

+ (NSDictionary *)JSONNestedResourceCollectionInboundMappingDictionary {
    return @{};
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    return NULL;
}

+ (NSArray *)polymorphicNestedResourcesKeys {
    return @[];
}

+ (NSString *)nameWhenAssociatedWith:(Class)associatedClass {
    return [self realmSingleForm];
}

#pragma mark - Tools

+ (NSDictionary*)renameResourceRootOf:(NSDictionary*)resource to:(NSString*)newRoot {
    // We know that it has a root (dictionary with one tuple).
    NSString* actualRoot = [resource allKeys].firstObject;
    if ([actualRoot isEqualToString:newRoot]) {
        return resource;
    }
    else {
        id body = [resource objectForKey:actualRoot];
        return @{newRoot : body};
    }
}


#pragma mark - Methods

+ (void)append:(NSArray*)newObjects to:(RLMArray*)collection {
    [collection removeAllObjects];
    [collection addObjects:newObjects];
}

+ (instancetype)createOrUpdateInRealm:(RLMRealm *)realm withJSONDictionary:(NSDictionary *)dictionary {
    ALMResource *result = [super createOrUpdateInRealm:realm withJSONDictionary:dictionary];
    
    NSDictionary *nestedCollectionProperties = [self JSONNestedResourceCollectionInboundMappingDictionary];
    for (NSString *apiCollectionPropertyName in nestedCollectionProperties) {
        NSString *resourceCollectionPropertyName = [nestedCollectionProperties objectForKey:apiCollectionPropertyName];
        
        NSArray *nestedResourceCollectionInResponse = [[dictionary objectForKey:self.jsonRoot] objectForKey:apiCollectionPropertyName];
        NSMutableArray *savedCollection = [NSMutableArray arrayWithCapacity:nestedResourceCollectionInResponse.count];
        
        Class propertyClass = [self propertyTypeForKRConstant:resourceCollectionPropertyName];
        for (NSDictionary* rawDic in nestedResourceCollectionInResponse) {
            NSDictionary* resourceDic = [self renameResourceRootOf:rawDic to:[propertyClass jsonRoot]];
            id nestedProperty = [propertyClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:)
                                                    withObject:realm
                                                    withObject:resourceDic];
            
            [savedCollection addObject:nestedProperty];
        }
        
        SEL collectionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@", resourceCollectionPropertyName]);
        if ([result respondsToSelector:collectionSelector]) {
            IMP imp = [result methodForSelector:collectionSelector];
            RLMArray* (*func)(id, SEL) = (void*)imp;
            RLMArray *resultNestedResourceCollection = func(result, collectionSelector);
            [self append:savedCollection to:resultNestedResourceCollection];
        }
        
        SEL parentSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [[self nameWhenAssociatedWith:propertyClass] capitalizedString]]);
        for (ALMResource *resource in savedCollection) {
            if([resource respondsToSelector:parentSelector]) {
                IMP imp = [resource methodForSelector:parentSelector];
                void (*func)(id, SEL, ALMResource*) = (void*)imp;
                func(resource, parentSelector, result);
            }
        }
    }
    
    NSDictionary *nestedProperties = [self JSONNestedResourceInboundMappingDictionary];
    for (NSString *apiPropertyName in nestedProperties) {
        NSString *resourcePropertyName = [nestedProperties objectForKey:apiPropertyName];
        
        id nestedResourceInResponse = [[dictionary objectForKey:self.jsonRoot] objectForKey:apiPropertyName];
        if (![nestedResourceInResponse isKindOfClass:[NSNull class]] && nestedResourceInResponse != nil) {
            
            Class propertyClass = NULL;
            
            if ([[self polymorphicNestedResourcesKeys] indexOfObject:apiPropertyName] != NSNotFound) {
                NSString* keyType = [ALMResourceConstants polymorphicATypeKey:apiPropertyName];
                NSString* polymorphicType = [nestedResourceInResponse objectForKey:keyType];
                
                propertyClass = [ALMResourceIndex classWithAPIName:polymorphicType];
                nestedResourceInResponse = [nestedResourceInResponse objectForKey:polymorphicType];
            }
            else {
                propertyClass = [self propertyTypeForKRConstant:resourcePropertyName];
            }
            
            if (propertyClass != NULL) {
                
                nestedResourceInResponse = @{[propertyClass jsonRoot] : nestedResourceInResponse};
                
                id nestedProperty = [propertyClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:)
                                                        withObject:realm
                                                        withObject:nestedResourceInResponse];
                
                SEL nestSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [resourcePropertyName capitalizedString]]);
                if ([result respondsToSelector:nestSelector]) {
                    IMP imp = [result methodForSelector:nestSelector];
                    void (*func)(id, SEL, ALMResource*) = (void*)imp;
                    func(result, nestSelector, nestedProperty);
                }
                
                SEL parentSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [[self nameWhenAssociatedWith:propertyClass] capitalizedString]]);
                if([nestedProperty respondsToSelector:parentSelector]) {
                    IMP imp = [nestedProperty methodForSelector:parentSelector];
                    void (*func)(id, SEL, ALMResource*) = (void*)imp;
                    func(nestedProperty, parentSelector, result);
                }
            }

        }
    }
    return result;
}

#pragma mark - Persistence

+ (ALMPersistMode)persistMode {
    return kPersistModeDefault;
}

#pragma mark - Loading

+ (id)objectForID:(long long)resourceID {
    return [self objectInRealm:[RLMRealm defaultRealm] forID:resourceID];
}

+ (id)objectInRealm:(RLMRealm *)realm forID:(long long)resourceID {
    return [self objectInRealm:realm forPrimaryKey:[NSNumber numberWithLongLong:resourceID]];
}

@end
