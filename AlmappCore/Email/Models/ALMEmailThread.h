//
//  ALMEmailThread.h
//  AlmappCore
//
//  Created by Patricio López on 27-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmail.h"

@interface ALMEmailThread : RLMObject

@property NSString *threadID;
@property NSString *snippet;
@property RLMArray<ALMEmail> *emails;

@end
RLM_ARRAY_TYPE(ALMEmailThread)
