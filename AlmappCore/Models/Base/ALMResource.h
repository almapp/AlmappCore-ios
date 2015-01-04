//
//  ALMResource.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "RLMObject.h"
#import "RLMObject+JSON.h"

@interface NSDictionary (ALMResource)

+ (NSDictionary*)merge:(NSDictionary*)dictionary1 with:(NSDictionary*)dictionary2;

@end

@interface ALMResource : RLMObject

@property NSInteger resourceID;

+ (NSString*)apiSingleForm;
+ (NSString*)apiPluralForm;
+ (NSString*)realmSingleForm;
+ (NSString*)realmPluralForm;

+ (NSString*)pluralForm;
+ (NSString*)singleForm;

+ (NSString*)jsonRoot;

- (NSString *)className;

+ (NSString*)pluralize:(NSString*)sentence;

+ (NSString*)jatt:(NSString*)attribute;

+ (id)objectInRealm:(RLMRealm *)realm ofType:(Class)resourceClass withID:(NSUInteger)resourceID;

@end
