//
//  ALMCustomController.m
//  AlmappCore
//
//  Created by Patricio López on 16-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCustomController.h"
#import "ALMCore.h"

@interface ALMCustomController ()

@property (strong, nonatomic) ALMSession *session;

@end

@implementation ALMCustomController

+ (instancetype)controllerForSession:(ALMSession *)session {
    return [[self alloc] init];
}

- (instancetype)initWithSession:(ALMSession *)session {
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

- (ALMController *)controller {
    ALMController *controller = [ALMCore controllerWithCredential:self.credential];
    controller.saveToRealm = YES;
    if (!controller.realm) {
        controller.realm = self.realm;
    }
    return controller;
}

- (ALMUser *)user {
    return self.session.user;
}

- (ALMCredential *)credential {
    return self.session.credential;
}

- (RLMRealm *)realm {
    return self.user.realm;
}

@end
