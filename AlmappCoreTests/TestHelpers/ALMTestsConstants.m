//
//  ALMTestsConstants.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMTestsConstants.h"

@implementation ALMTestsConstants

NSString * const kTestingBaseURL = @"http://patiwi-mcburger-pro.local:3000";
short const kTestingApiVersion = 1;

+ (ALMApiKey *)testingApiKey {
    return [ALMApiKey apiKeyWithClient:@"f1328a3ccd975185990322e0d1a02c34c014933018818fc4c4bf93f9e83f458e"
                                secret:@"36ab39dfeb5065562c0427673d43f3d08cd39dd891d2eea0e4af2f5c2611073d"];
}

@end
