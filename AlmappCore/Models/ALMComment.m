//
//  ALMComment.m
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMComment.h"
#import "ALMUser.h"
#import "ALMResourceConstants.h"

@implementation ALMComment

@synthesize likes = _likes;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kAComment]          : kRComment,
             [self jatt:kAIsHidden]         : kRIsHidden,
             [self jatt:kAIsAnonymous]      : kRIsAnonymous,
             [self jatt:kAUpdatedAt]        : kRUpdatedAt,
             [self jatt:kACreatedAt]        : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRComment                      : kRDefaultNullString,
             kRIsHidden                     : @NO,
             kRIsAnonymous                  : @NO,
             kRPolymorphicCommentableType   : kRDefaultPolymorphicType,
             kRPolymorphicCommentableID     : @0,
             kRUpdatedAt                    : [NSDate distantPast],
             kRCreatedAt                    : [NSDate distantPast]
             };
}

-(void)setCommentable:(ALMResource<ALMCommentable>*)commentable {
    [self setCommentableID:commentable.resourceID];
    [self setCommentableType:commentable.className];
}

- (id)commentable {
    Class commentableClass = NSClassFromString(self.commentableType);
    return [ALMResource objectInRealm:[self realm] ofType:commentableClass withID:self.commentableID];
}

+ (ALMPersistMode)persistMode {
    return ALMPersistModeDuringSession;
}

- (NSUInteger)positiveLikeCount {
    return [ALMLike positiveLikeCountFor:self];
}

- (NSUInteger)negativeLikeCount {
    return [ALMLike negativeLikeCountFor:self];
}

@end
