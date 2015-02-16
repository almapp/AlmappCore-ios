//
//  ALMResource.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Realm+JSON/RLMObject+Copying.h>

#import "ALMResource.h"
#import "ALMResourceConstants.h"
#import "ALMResourceIndex.h"

ALMPersistMode const kPersistModeDefault = ALMPersistModeMuchAsPosible;



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

- (id)copyWithZone:(NSZone *)zone {
    return [self shallowCopy];
}

- (NSString *)className {
    return [[self class] className];
}

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]     : kRResourceID
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return [[self JSONInboundMappingDictionary] invert];
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

- (id<NSFastEnumeration>)hasMany:(NSObject<NSFastEnumeration> *)resources {
    NSString *nestedCollectionName = [[resources performSelector:@selector(firstObject)] performSelector:@selector(realmPluralForm)];
    return [self hasMany:resources as:nestedCollectionName];
}

- (id<NSFastEnumeration>)hasMany:(NSObject<NSFastEnumeration> *)resources as:(NSString *)collectionProperty {
    NSString *resourceParentName = [self.class performSelector:@selector(realmSingleForm)];
    return [self hasMany:resources as:collectionProperty belongsToAs:resourceParentName];
}

- (id<NSFastEnumeration>)hasMany:(NSObject<NSFastEnumeration> *)resources as:(NSString *)collectionProperty belongsToAs:(NSString *)parentName {
    
    SEL collectionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@", collectionProperty]);
    SEL parentSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [parentName capitalizedString]]);
    
    if ([self respondsToSelector:collectionSelector]) {
        IMP imp = [self methodForSelector:collectionSelector];
        RLMArray* (*func)(id, SEL) = (void*)imp;
        RLMArray *parentNestedResourcecollection = func(self, collectionSelector);
        
        [parentNestedResourcecollection removeAllObjects];
        [parentNestedResourcecollection addObjects:resources];
    }
    
    for (ALMResource *resource in resources) {
        if([resource respondsToSelector:parentSelector]) {
            IMP imp = [resource methodForSelector:parentSelector];
            void (*func)(id, SEL, ALMResource*) = (void*)imp;
            func(resource, parentSelector, self);
        }
    }
    
    return resources;
}


+ (instancetype)createOrUpdateInRealm:(RLMRealm *)realm withJSONDictionary:(NSDictionary *)dictionary {
    ALMResource *result = [super createOrUpdateInRealm:realm withJSONDictionary:dictionary];
    
    NSDictionary *nestedCollectionProperties = [self JSONNestedResourceCollectionInboundMappingDictionary];
    for (NSString *apiCollectionPropertyName in nestedCollectionProperties.allKeys) {
        NSString *resourceCollectionPropertyName = [nestedCollectionProperties objectForKey:apiCollectionPropertyName];
        
        NSArray *nestedResourceCollectionInResponse = [[dictionary objectForKey:self.jsonRoot] objectForKey:apiCollectionPropertyName];
        NSMutableArray *savedCollection = [NSMutableArray arrayWithCapacity:nestedResourceCollectionInResponse.count];
        
        Class propertyClass = [self propertyTypeForKRConstant:resourceCollectionPropertyName];
        for (NSDictionary* rawDic in nestedResourceCollectionInResponse) {
            
            NSDictionary* resourceDic = nil;
            if ([propertyClass isSubclassOfClass:[ALMResource class]]) {
                resourceDic = [self renameResourceRootOf:rawDic to:[propertyClass jsonRoot]];
            }
            else {
                resourceDic = rawDic;
            }
            
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
    for (NSString *apiPropertyName in nestedProperties.allKeys) {
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

+ (id)objectWithID:(long long)resourceID {
    return [self objectInRealm:[RLMRealm defaultRealm] withID:resourceID];
}

+ (id)objectInRealm:(RLMRealm *)realm withID:(long long)resourceID {
    return [self objectInRealm:realm forPrimaryKey:[NSNumber numberWithLongLong:resourceID]];
}

+ (id)objectOfType:(Class)resourceClass withID:(long long)resourceID {
    return [self objectOfType:resourceClass withID:resourceID inRealm:[RLMRealm defaultRealm]];
}

+ (id)objectOfType:(Class)resourceClass withID:(long long)resourceID inRealm:(RLMRealm *)realm {
    return [resourceClass objectInRealm:realm withID:resourceID];
}


+ (RLMResults *)allObjectsOfType:(Class)resourceClass {
    return [self allObjectsOfType:resourceClass inRealm:[RLMRealm defaultRealm]];
}

+ (RLMResults *)allObjectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm {
    return [resourceClass allObjectsInRealm:realm];
}

+ (RLMResults *)objectsOfType:(Class)resourceClass where:(NSString *)query {
    return [self objectsOfType:resourceClass inRealm:[RLMRealm defaultRealm] where:query];
}

+ (RLMResults *)objectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm where:(NSString *)query {
    if (query && query.length > 0) {
        return [resourceClass objectsInRealm:realm where:query];
    }
    else {
        return [resourceClass allObjectsInRealm:realm];
    }
}

+ (RLMResults *)objectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm withProperty:(NSString *)property in:(NSArray *)array {
    NSString *query = [NSString stringWithFormat:@"%@ IN %@", property, [array toRealmStringArray]];
    return [ALMResource objectsOfType:resourceClass inRealm:realm where:query];
}

+ (RLMResults *)objectsInRealm:(RLMRealm *)realm withProperty:(NSString *)property in:(NSArray *)array {
    return [self objectsOfType:self.class inRealm:realm withProperty:property in:array];
}


+ (RLMResults *)objectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm withIDs:(NSArray *)array {
    return [self objectsOfType:resourceClass inRealm:realm withProperty:kRResourceID in:array];
}

+ (RLMResults *)objectsInRealm:(RLMRealm *)realm withIDs:(NSArray *)array {
    return [self objectsOfType:self.class inRealm:realm withIDs:array];
}

@end
