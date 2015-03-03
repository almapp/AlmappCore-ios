//
//  ALMEmailManager.h
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMEmailController.h"

@interface ALMEmailManager : NSObject

+ (instancetype)emailManager:(ALMSession *)session;

@property (readonly) ALMSession *session;
@property (readonly) ALMEmailController *emailController;

- (PMKPromise *)fetchThreadsWithEmails:(ALMEmailLabel)labels;

@end
