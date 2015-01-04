//
//  ALMCommentable.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMComment.h"

@protocol ALMCommentable <NSObject>

@property RLMArray<ALMComment> *comments;

@end