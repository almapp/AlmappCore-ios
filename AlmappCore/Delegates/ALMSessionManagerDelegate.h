//
//  ALMSessionManagerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALMSession.h"

@protocol ALMSessionManagerDelegate <NSObject>

- (NSDictionary *)loginParams:(ALMSession *)session;
- (NSString *)loginPostPath:(ALMSession *)session;

- (ALMSession *)currentSession;
- (void)setCurrentSession:(ALMSession *)session;

@end