//
//  ALMPostTargetable.h
//  AlmappCore
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMPost.h"

@protocol ALMPostTargetable <NSObject>

@property RLMArray<ALMPost> *posts;

@end