//
//  ALMApiKey.h
//  AlmappCore
//
//  Created by Patricio López on 30-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALMApiKey : NSObject

@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;

+ (instancetype)apiKeyWithClient:(NSString *)client secret:(NSString *)secret;

@end
