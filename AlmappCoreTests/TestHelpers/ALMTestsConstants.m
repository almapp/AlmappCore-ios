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
NSString * const kTestingOrganization = @"UC";
short const kTestingApiVersion = 1;

+ (ALMApiKey *)testingApiKey {
    return [ALMApiKey apiKeyWithClient:@"21152d48ce94f7afd7a60cbf97e33608b8b43732c58559c059fb74b5269917a2"
                                secret:@"f45b7301260954f4723f69c2f6dab09c1eb7f3b9ff11c93a2eb0bcbef696609d"];
}

@end
