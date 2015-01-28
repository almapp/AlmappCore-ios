//
//  ALMTestCase.h
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AlmappCore.h"
#import "ALMTestsConstants.h"

@interface ALMTestCase : XCTestCase <ALMCoreDelegate>

@property (readonly) ALMCore *core;

@property (readonly) RLMRealm* testRealm;

@property (readonly) NSString* testRealmPath;

@property (readonly) ALMRequestManager *requestManager;

@property (readonly) NSTimeInterval timeout;

@end
