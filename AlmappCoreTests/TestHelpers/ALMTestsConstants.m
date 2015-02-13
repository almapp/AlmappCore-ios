//
//  ALMTestsConstants.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMTestsConstants.h"

@implementation ALMTestsConstants

NSString * const kTestingBaseURL = @"http://patiwi-mcburger-pro.local:3000/"; //@"https://almapp.me";
NSString * const kTestingOrganization = @"UC";
short const kTestingApiVersion = 1;

+ (ALMApiKey *)testingApiKey {
    return [ALMApiKey apiKeyWithClient:@"ee15d02a0a6a1cd6e1222109db844942b5f4decc99c1e02d573648a73e6833b4"
                                secret:@"8507e90ad502e52ece94391409fb5882acdaf6bffe82a5600b1806791f384452"];
}

@end
