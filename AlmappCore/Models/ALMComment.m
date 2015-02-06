//
//  ALMComment.m
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMComment.h"
#import "ALMUser.h"
#import "ALMLike.h"
#import "ALMResourceConstants.h"

@implementation ALMComment

@synthesize likes = _likes;
@synthesize likesCount = _likesCount, dislikesCount = _dislikesCount;

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
             kRPolymorphicCommentableID     : kRDefaultPolymorphicID,
             kRUpdatedAt                    : [NSDate defaultDate],
             kRCreatedAt                    : [NSDate defaultDate]
             };
}

-(void)setCommentable:(ALMResource<ALMCommentable>*)commentable {
    [self setCommentableID:[commentable resourceID]];
    [self setCommentableType:[commentable className]];
}

- (ALMResource<ALMCommentable>*)commentable {
    Class commentableClass = NSClassFromString(self.commentableType);
    return [commentableClass objectInRealm:self.realm withID:self.commentableID];
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
