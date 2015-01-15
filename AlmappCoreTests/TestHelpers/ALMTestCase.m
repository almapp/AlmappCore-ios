//
//  ALMTestCase.m
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMTestCase.h"
#import "ALMDummyCoreDelegated.h"

@implementation ALMTestCase

- (void)setUp {
    [super setUp];
    
    _core = [ALMCore initInstanceWithDelegate:[[ALMDummyCoreDelegated alloc] init] baseURL:[NSURL URLWithString:kTestingBaseURL]];
}

- (void)tearDown {
    [super tearDown];
    
    [_core dropDatabaseInMemory];
    [_core dropDatabaseDefault];
}

- (RLMRealm *)testRealm {
    return [_core requestTemporalRealm];
}

@end
