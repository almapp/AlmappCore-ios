//
//  ALMApiKey.m
//  AlmappCore
//
//  Created by Patricio López on 30-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMApiKey.h"

@implementation ALMApiKey

+ (instancetype)apiKeyWithClient:(NSString *)client secret:(NSString *)secret {
    ALMApiKey *apiKey = [[self alloc] init];
    apiKey.clientID = client;
    apiKey.clientSecret = secret;
    return apiKey;
}

@end
