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
    
    _core = [ALMCore coreWithDelegate:self baseURL:[NSURL URLWithString:kTestingBaseURL] apiVersion:kTestingApiVersion apiKey:[ALMTestsConstants testingApiKey]  organization:kTestingOrganization];
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

- (ALMController *)controllerWithAuth {
    return [_core controllerWithCredential:self.testSession.credential];
}

- (NSTimeInterval)timeout {
    return 3000;
}

- (ALMSession *)testSession {
    if (!_testSession) {
        RLMRealm *realm = self.testRealm;
        _testSession = [ALMSession sessionWithEmail:@"lorem1@uc.cl" password:@"randompassword" inRealm:realm];
        
        ALMUser *user = [[ALMUser alloc] init];
        user.name = @"Lorema Ipsum";
        user.username = @"lorem1";
        user.country = @"Chile";
        user.email = @"lorem1@uc.cl";
        user.isFindeable = YES;
        user.isMale = NO;
        user.studentID = @"126332331";
        
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:user];
            _testSession.user = user;
        }];

    }
    return _testSession;
}

@end
