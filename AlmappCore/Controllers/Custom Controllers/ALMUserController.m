//
//  ALMUserController.m
//  AlmappCore
//
//  Created by Patricio López on 16-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMUserController.h"
#import "ALMCore.h"
#import "ALMTemporalCredential.h"

@implementation ALMUserController

- (PMKPromise *)login:(NSString *)email password:(NSString *)password {
    return [self login:email password:password realm:[RLMRealm defaultRealm]];
}

- (PMKPromise *)login:(NSString *)email password:(NSString *)password realm:(RLMRealm *)realm {
    ALMCredential *credential = [ALMTemporalCredential credentialForEmail:email password:password];
    
    ALMController *controller = [ALMCore controllerWithCredential:credential];
    
    NSString *realmPath = realm.path;
    
    return [controller GET:@"me" parameters:nil].then( ^(NSDictionary *JSON, NSURLSessionDataTask *task) {
        [credential save];
        
        RLMRealm *realm = [RLMRealm realmWithPath:realmPath];
        
        [realm beginWriteTransaction];
        
        ALMSession *session = [[ALMSession alloc] init];
        session.email = email;
        session = [ALMSession createOrUpdateInRealm:realm withObject:session];
        session.user = [ALMUser createOrUpdateInRealm:realm withJSONDictionary:JSON];
        
        [realm commitWriteTransaction];
        
        return session;
        
    }).catch( ^(NSError *error) {
        [ALMCore deallocControllerWithCredential:credential];
        return error;
    });
}

@end
