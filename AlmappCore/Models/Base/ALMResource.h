//
//  ALMResource.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "RLMObject.h"

@interface ALMResource : RLMObject

+ (NSString*)pluralForm;
+ (NSString*)singleForm;

@end
