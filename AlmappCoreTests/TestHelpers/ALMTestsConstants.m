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
    return [ALMApiKey apiKeyWithClient:@"f225e4889aee29c2d3f0e81dd2dd72b219c502ecb2f1e2bb57b63440e50f009a"
                                secret:@"cb835b51f079a6fa4ed52832c0e409f24c4e29987f2069c709b092580d77cd49"];
}

@end
