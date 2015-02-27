//
//  ALMEmailManager.m
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMEmailManager.h"

@interface ALMEmailManager ()

@property (strong, nonatomic) ALMSession *session;
@property (strong, nonatomic) ALMEmailController *emailController_;

@end

@implementation ALMEmailManager

+ (instancetype)emailManager:(ALMSession *)session {
    return [[self alloc] initWithSession:session];
}

- (instancetype)initWithSession:(ALMSession *)session {
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

- (PMKPromise *)fetchEmailsInFolder:(ALMEmailFolder *)folder {
    return nil;
}

- (ALMEmailController *)emailController {
    if (!_emailController_) {
        _emailController_ = [ALMEmailController controllerForSession:self.session];
    }
    return _emailController_;
}

@end
