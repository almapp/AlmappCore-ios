//
//  ALMLikeable.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMLike;
@protocol ALMLike;

@protocol ALMLikeable <NSObject>

@property RLMArray<ALMLike> *likes;
@property NSInteger likesCount;
@property NSInteger dislikesCount;

@end