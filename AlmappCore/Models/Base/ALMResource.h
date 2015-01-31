//
//  ALMResource.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "RLMObject.h"
#import "RLMObject+JSON.h"

#pragma mark - Persistence Declarations

typedef NS_ENUM(NSUInteger, ALMPersistMode) {
    ALMPersistModeNone,
    ALMPersistModeDuringSession,
    ALMPersistModeMuchAsPosible,
    ALMPersistModeForever,
};

extern ALMPersistMode const kPersistModeDefault;

#pragma mark - Dictionary Category

@interface NSDictionary (ALMResource)

+ (NSDictionary*)merge:(NSDictionary*)dictionary1 with:(NSDictionary*)dictionary2;

@end

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

+ (id)allObjectsOfType:(Class)resourceClass;
+ (id)allObjectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm;

+ (id)objectsOfType:(Class)resourceClass where:(NSString *)query;
+ (id)objectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm where:(NSString *)query;

+ (RLMResults *)objectsInRealm:(RLMRealm *)realm withIDs:(NSArray *)array;
+ (RLMResults *)objectsOfType:(Class)resourceClass inRealm:(RLMRealm *)realm withIDs:(NSArray *)array;

@end
