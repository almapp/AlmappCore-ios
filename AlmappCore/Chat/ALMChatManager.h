//
//  ALMChatManager.h
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMChatManagerDelegate.h"

@interface ALMChatManager : NSObject

@property (weak, nonatomic) id<ALMChatManagerDelegate> chatManagerDelegate;

@property (readonly) NSURL* chatUrl;

+ (instancetype)chatManagerWithURL:(NSURL *)url;

@end
