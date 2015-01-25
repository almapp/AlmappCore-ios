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
    
    _core = [ALMCore initInstanceWithDelegate:[[ALMDummyCoreDelegated alloc] init] baseURL:[NSURL URLWithString:kTestingBaseURL] apiKey:kTestingApiKey];
}

- (void)tearDown {
    [super tearDown];
    
    [_core dropTemporalDatabase];
    [_core deleteTemporalDatabase];
}

- (RLMRealm *)testRealm {
    return [_core temporalRealm];
}

- (ALMRequestManager *)requestManager {
    return [_core requestManager];
}

- (NSTimeInterval)timeout {
    return 20;
}

@end
