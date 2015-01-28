//
//  ALMConversable.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMChat;

@protocol ALMConversable <NSObject>

@property ALMChat *chat;

@end