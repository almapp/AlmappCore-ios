//
//  ALMEventHoster.h
//  AlmappCore
//
//  Created by Patricio López on 15-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMEvent.h"

@protocol ALMEventHost <NSObject>

@property RLMArray<ALMEvent> *events;

@end