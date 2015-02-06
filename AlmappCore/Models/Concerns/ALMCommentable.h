//
//  ALMCommentable.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMComment;
@protocol ALMComment;

@protocol ALMCommentable <NSObject>

@property RLMArray<ALMComment> *comments;
@property NSInteger commentsCount;

@end