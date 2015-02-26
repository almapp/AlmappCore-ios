//
//  ALMTestsConstants.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMTestsConstants.h"

@implementation ALMTestsConstants

// NSString * const kTestingBaseURL = @"https://almapp.me";
NSString * const kTestingBaseURL = @"http://patiwi-mcburger-pro.local:5000/";
NSString * const kTestingOrganization = @"UC";
short const kTestingApiVersion = 1;

+ (ALMApiKey *)testingApiKey {
    return [ALMApiKey apiKeyWithClient:@"0a6e77365356c94f322ebdc2819de92600dd821e48072a921e1f671276efac56"
                                secret:@"c221f9d0df564a26bfda08196cc9cc221df856ee5ee71e51c348ad105deabd13"];
}

@end
