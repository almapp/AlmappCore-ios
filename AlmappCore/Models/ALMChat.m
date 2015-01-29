//
//  ALMChat.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMChat.h"
#import "ALMUser.h"
#import "ALMResourceConstants.h"

@implementation ALMChat

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]                   : kRResourceID,
             [self jatt:kATitle]                        : kRTitle,
             [self jatt:kAIsAvailable]                  : kRIsAvailable,
             [self jatt:kAPolymorphicConversableType]   : kRPolymorphicConversableType,
             [self jatt:kAPolymorphicConversableID]     : kRPolymorphicConversableID,
             [self jatt:kAUpdatedAt]                    : kRUpdatedAt,
             [self jatt:kACreatedAt]                    : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRTitle                         : kRDefaultNullString,
             kRIsAvailable                   : kRDefaultNullString,
             kRPolymorphicConversableType    : kRDefaultPolymorphicType,
             kRPolymorphicConversableID      : kRDefaultPolymorphicID,
             kRUpdatedAt                     : [NSDate defaultDate],
             kRCreatedAt                     : [NSDate defaultDate]
             };
}

- (void)setConversable:(ALMResource *)conversable {
    [self setConversableID:[conversable resourceID]];
    [self setConversableType:[conversable className]];
}

- (ALMResource *)conversable {
    Class conversableClass = NSClassFromString(self.conversableType);
    return [conversableClass objectInRealm:self.realm withID:self.conversableID];
}

@end
