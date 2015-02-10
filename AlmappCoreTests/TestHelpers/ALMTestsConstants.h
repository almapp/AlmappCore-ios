//
//  ALMTestsConstants.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMApiKey.h"

@interface ALMTestsConstants : NSObject

extern NSString * const kTestingBaseURL;
extern NSString * const kTestingOrganization;
extern short const kTestingApiVersion;

+ (ALMApiKey *)testingApiKey;

@end
