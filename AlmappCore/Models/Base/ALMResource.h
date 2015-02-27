//
//  ALMResource.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Realm+JSON/RLMObject+JSON.h>
#import <Realm+JSON/RLMObject+Copying.h>
#import "RLMResults+Select.h"
#import "RLMArray+Select.h"
#import "NSArray+Query.h"
#import "NSDictionary+Util.h"

#pragma mark - Persistence Declarations

typedef NS_ENUM(NSUInteger, ALMPersistMode) {
    ALMPersistModeNone,
    ALMPersistModeDuringSession,
    ALMPersistModeMuchAsPosible,
    ALMPersistModeForever,
};

extern ALMPersistMode const kPersistModeDefault;

#pragma mark - String Category

@interface NSString (ALMResource)

- (NSString*)pluralize;

@end

#pragma mark - Date Category

@interface NSDate (ALMResource)

+ (NSDate*)defaultDate;
+ (NSDate*)defaultEventDate;

@end

#pragma mark - Resource header

@interface ALMResource : RLMObject <NSCopying>

@property long long resourceID;

- (NSString *)className;

- (id<NSFastEnumeration>)hasMany:(NSObject<NSFastEnumeration> *)resources;
- (id<NSFastEnumeration>)hasMany:(NSObject<NSFastEnumeration> *)resources as:(NSString *)collectionProperty;
- (id<NSFastEnumeration>)hasMany:(NSObject<NSFastEnumeration> *)resources as:(NSString *)collectionProperty belongsToAs:(NSString *)parentName;

#pragma mark - Attributes helpers

+ (NSString*)apiSingleForm;
+ (NSString*)apiPluralForm;
+ (NSString*)realmSingleForm;
+ (NSString*)realmPluralForm;

- (NSString*)apiSingleForm;
- (NSString*)apiPluralForm;
- (NSString*)realmSingleForm;
- (NSString*)realmPluralForm;

#pragma mark - Lexic helpers

+ (NSString*)pluralForm;
+ (NSString*)singleForm;

- (NSString*)pluralForm;
- (NSString*)singleForm;

#pragma mark - JSON helpers

+ (NSString*)jsonRoot;

- (NSString*)jsonRoot;

+ (NSString*)jatt:(NSString*)attribute;

#pragma mark - Methods

+ (NSDictionary*)JSONNestedResourceInboundMappingDictionary;
+ (NSDictionary*)JSONNestedResourceCollectionInboundMappingDictionary;
+ (Class)propertyTypeForKRConstant:(NSString*)kr;
+ (NSArray*)polymorphicNestedResourcesKeys;
+ (NSString*)nameWhenAssociatedWith:(Class)associatedClass;

#pragma mark - Tools

+ (NSDictionary*)renameResourceRootOf:(NSDictionary*)resource to:(NSString*)newRoot;

#pragma mark - Persistence

+ (ALMPersistMode)persistMode;

#pragma mark - Loading

+ (id)objectInRealm:(RLMRealm *)realm withID:(long long)resourceID;
+ (id)objectWithID:(long long)resourceID;
+ (id)objectOfType:(Class)resourceClass withID:(long long)resourceID;
+ (id)objectOfType:(Class)resourceClass withID:(long long)resourceID inRealm:(RLMRealm *)realm;

+ (RLMResults *)allObjectsOfType:(Class)resourceClass;
+ (RLMResults *)allObjectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm;

+ (RLMResults *)objectsOfType:(Class)resourceClass where:(NSString *)query;
+ (RLMResults *)objectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm where:(NSString *)query;

+ (RLMResults *)objectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm withProperty:(NSString *)property in:(NSArray *)array;
+ (RLMResults *)objectsInRealm:(RLMRealm *)realm withProperty:(NSString *)property in:(NSArray *)array;

+ (RLMResults *)objectsInRealm:(RLMRealm *)realm withIDs:(NSArray *)array;
+ (RLMResults *)objectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm withIDs:(NSArray *)array;

@end
