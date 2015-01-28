//
//  ALMChat.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMChat.h"
#import "ALMUser.h"

@implementation ALMChat

- (void)setConversable:(ALMResource *)conversable {
    [self setConversableID:[conversable resourceID]];
    [self setConversableType:[conversable className]];
}

- (ALMResource *)conversable {
    Class conversableClass = NSClassFromString(self.conversableType);
    return [conversableClass objectInRealm:self.realm withID:self.conversableID];
}

@end
