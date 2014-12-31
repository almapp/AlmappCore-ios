//
//  ALMUser.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"

@interface ALMUser : ALMResource

@property NSInteger resourceID;
@property NSString *name;
@property NSString *username;
@property NSString *email;
@property BOOL male;

@end
RLM_ARRAY_TYPE(ALMUser)