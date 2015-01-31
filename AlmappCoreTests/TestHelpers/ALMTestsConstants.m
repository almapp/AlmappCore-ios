//
//  ALMTestsConstants.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMTestsConstants.h"

@implementation ALMTestsConstants

NSString * const kTestingBaseURL = @"http://patiwi-mcburger-pro.local:3000/";
short const kTestingApiVersion = 1;

+ (ALMApiKey *)testingApiKey {
    return [ALMApiKey apiKeyWithClient:@"b94e4d9be176d67bb42a2972a2bf96f538d5ff51096ecac7a6b88ea975093585"
                                secret:@"80ad86434af326d43f8eb0e16b928451090225583b3f2151f256f1c2ebff5d4f"];
}

@end
