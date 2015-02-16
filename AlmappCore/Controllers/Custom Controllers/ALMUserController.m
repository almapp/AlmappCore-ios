//
//  ALMUserController.m
//  AlmappCore
//
//  Created by Patricio López on 16-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMUserController.h"

@implementation ALMUserController

- (PMKPromise *)login {
    return [self.controller GET:@"me" parameters:nil].then( ^(NSDictionary *JSON, NSURLSessionDataTask *task) {
        RLMRealm *realm = self.realm;
        
        [realm beginWriteTransaction];
        
        ALMUser *user = [ALMUser createOrUpdateInRealm:self.realm withJSONDictionary:JSON];
        self.session.user = user;
        
        [realm commitWriteTransaction];
        
        return self.session;
    });
}

@end
