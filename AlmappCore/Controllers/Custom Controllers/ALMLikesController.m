//
//  ALMLikesController.m
//  AlmappCore
//
//  Created by Patricio López on 15-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMLikesController.h"
#import "ALMCore.h"

@interface ALMLikesController ()

@property (weak, nonatomic) ALMSession *session;

@end

@implementation ALMLikesController

+ (instancetype)controllerForSession:(ALMSession *)session {
    ALMLikesController *controller = [[ALMLikesController alloc] init];
    controller.session = session;
    return controller;
}

- (ALMController *)controller {
    return [ALMCore controllerWithCredential:self.session.credential];
}

- (PMKPromise *)like:(ALMResource<ALMLikeable> *)likeable {
    NSString *path = [NSString stringWithFormat:@"%@/%lld/like", [likeable apiPluralForm], likeable.resourceID];
    
    return [self.controller POST:path parameters:nil];
}

- (PMKPromise *)dislike:(ALMResource<ALMLikeable> *)likeable {
    NSString *path = [NSString stringWithFormat:@"%@/%lld/dislike", [likeable apiPluralForm], likeable.resourceID];
    
    return [self.controller POST:path parameters:nil];
}

@end
