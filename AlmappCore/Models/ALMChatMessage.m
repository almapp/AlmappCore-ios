//
//  ALMChatMessage.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMChatMessage.h"
#import "ALMResourceConstants.h"

@implementation ALMChatMessage

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]                   : kRResourceID,
             [self jatt:kAContent]                      : kRContent,
             [self jatt:kAIsFlagged]                    : kRIsFlagged,
             [self jatt:kAIsHidden]                     : kRIsHidden,
             [self jatt:kAUpdatedAt]                    : kRUpdatedAt,
             [self jatt:kACreatedAt]                    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRContent                      : kRDefaultNullString,
             kRIsFlagged                    : @NO,
             kRIsHidden                     : @NO,
             kRUpdatedAt                    : [NSDate defaultDate],
             kRCreatedAt                    : [NSDate defaultDate]
             };
}

@end