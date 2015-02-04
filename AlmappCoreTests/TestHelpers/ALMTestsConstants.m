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
    return [ALMApiKey apiKeyWithClient:@"2756ccf6fb36b39266f0c3e14011ff00a59bc8b3fbc79edad74b657155a0f017"
                                secret:@"d05024a3f4f57c1dbb7b3f46ec1b5310d69a5682103f80ea1c0bb226327f367a"];
}

@end
