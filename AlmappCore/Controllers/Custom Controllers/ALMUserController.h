//
//  ALMUserController.h
//  AlmappCore
//
//  Created by Patricio López on 16-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCustomController.h"

@interface ALMUserController : ALMCustomController

- (PMKPromise *)login:(NSString *)email password:(NSString *)password;
- (PMKPromise *)login:(NSString *)email password:(NSString *)password realm:(RLMRealm *)realm;

@end
