//
//  ALMUser.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"

@interface ALMUser : ALMResource

@property NSString *name;
@property NSString *username;
@property NSString *email;
@property NSString *studentId;
@property NSString *country;
@property BOOL findeable;
@property BOOL male;
@property NSDate *lastSeen;

@end
RLM_ARRAY_TYPE(ALMUser)