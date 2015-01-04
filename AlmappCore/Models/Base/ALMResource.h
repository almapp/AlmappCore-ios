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

#pragma mark - Resource header

@interface ALMResource : RLMObject

@property NSInteger resourceID;

- (NSString *)className;

#pragma mark - Attributes helpers

+ (NSString*)apiSingleForm;
+ (NSString*)apiPluralForm;
+ (NSString*)realmSingleForm;
+ (NSString*)realmPluralForm;

#pragma mark - Lexic helpers

+ (NSString*)pluralForm;
+ (NSString*)singleForm;

#pragma mark - JSON helpers

+ (NSString*)jsonRoot;
+ (NSString*)jatt:(NSString*)attribute;

#pragma mark - Persistence

+ (ALMPersistMode)persistMode;

+ (id)objectInRealm:(RLMRealm *)realm ofType:(Class)resourceClass withID:(NSUInteger)resourceID;

@end
