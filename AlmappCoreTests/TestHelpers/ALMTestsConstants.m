//
//  ALMTestsConstants.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMTestsConstants.h"

@implementation ALMTestsConstants

NSString * const kTestingBaseURL = @"http://almapp.me"; //@"http://patiwi-mcburger-pro.local:3000";
short const kTestingApiVersion = 1;

+ (ALMApiKey *)testingApiKey {
    return [ALMApiKey apiKeyWithClient:@"c970e1f8282992baa673e3609753dc8bd746c4d7931b9a65ab1cab073be1f03e"
                                secret:@"3d834a31a2a65a8a0aa5a7c46d25a149b4c7282fc7d6d04977375ad4ae469459"];
}

@end
