//
//  ALMTestsConstants.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMTestsConstants.h"

@implementation ALMTestsConstants

NSString * const kTestingBaseURL = @"https://almapp.me";
// NSString * const kTestingBaseURL = @"http://patiwi-mcburger-pro.local:3000/";
NSString * const kTestingOrganization = @"UC";
short const kTestingApiVersion = 1;

+ (ALMApiKey *)testingApiKey {
    return [ALMApiKey apiKeyWithClient:@"d7d7613422a9cb2700d3bc9480289c806cee47805b3b8630139736db3627baa7"
                                secret:@"1dc112e063a38cebd76e3235e997318e4c724f9d27cf3b3df3def0e7355bd8a2"];
}

@end
