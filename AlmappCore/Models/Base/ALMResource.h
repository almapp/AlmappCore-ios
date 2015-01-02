//
//  ALMResource.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "RLMObject.h"
#import "RLMObject+JSON.h"

@interface ALMResource : RLMObject

@property NSInteger resourceID;
//@property NSDate *updatedAt;
//@property NSDate *createdAt;

+ (NSString*)pluralForm;
+ (NSString*)singleForm;
+ (NSString*)jsonRoot;
+ (NSString*)jatt:(NSString*)attribute;
+ (id)objectInRealm:(RLMRealm *)realm ofType:(Class)resourceClass withID:(NSUInteger)resourceID;

@end
