//
//  ALMTestCase.m
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMTestCase.h"

@implementation ALMTestCase

- (void)setUp {
    [super setUp];
    
    _core = [ALMCore coreWithDelegate:self baseURL:[NSURL URLWithString:kTestingBaseURL] apiVersion:kTestingApiVersion apiKey:[ALMTestsConstants testingApiKey]];
    [_core deleteTemporalDatabase];
}

- (void)tearDown {
    [super tearDown];
    [_core shutDown];
}

- (RLMRealm *)testRealm {
    return [_core temporalRealm];
}

- (NSString *)testRealmPath {
    return self.testRealm.path;
}

- (ALMController *)controller {
    return [_core controller];
}

- (NSTimeInterval)timeout {
    return 3000;
}

- (ALMSession *)testSession {
    if (!_testSession) {
        RLMRealm *realm = self.testRealm;
        _testSession = [ALMSession sessionWithEmail:@"pelopez2@uc.cl" password:@"randompassword" inRealm:realm];
    }
    return _testSession;
}

@end
