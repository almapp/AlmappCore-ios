//
//  ALMCustomController.h
//  AlmappCore
//
//  Created by Patricio López on 16-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMSession.h"
#import "ALMController.h"

@interface ALMCustomController : NSObject

@property (readonly) ALMSession *session;
@property (readonly) ALMUser *user;
@property (readonly) ALMCredential *credential;
@property (readonly) RLMRealm *realm;

+ (instancetype)controllerForSession:(ALMSession *)session;
+ (instancetype)controller;

- (instancetype)initWithSession:(ALMSession *)session;

- (ALMController *)controller;

@end
