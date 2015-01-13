//
//  ALMLike.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"

@protocol ALMLikeable;

@class ALMUser;

@interface ALMLike : ALMResource

@property ALMUser *user;
@property NSInteger valuation;
@property NSString *likeableType;
@property long long likeableID;

- (void)setLikeable:(ALMResource<ALMLikeable>*)likeable;
- (ALMResource<ALMLikeable>*)likeable;

#pragma mark - Like helpers

+ (RLMResults*)positiveLikesFor:(ALMResource<ALMLikeable>*)likeable;
+ (RLMResults*)negativeLikesFor:(ALMResource<ALMLikeable>*)likeable;

+ (NSUInteger)positiveLikeCountFor:(ALMResource<ALMLikeable>*)likeable;
+ (NSUInteger)negativeLikeCountFor:(ALMResource<ALMLikeable>*)likeable;

@end
RLM_ARRAY_TYPE(ALMLike)