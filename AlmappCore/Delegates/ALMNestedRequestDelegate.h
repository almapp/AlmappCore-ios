//
//  ALMNestedRequestDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMRequestDelegate.h"

@class RLMRealm, RLMResults, ALMResource;
@class ALMController, ALMResourceRequest;

@protocol ALMNestedRequestDelegate <ALMRequestDelegate>

@optional

- (void)request:(ALMResourceRequest *)request didFetchParent:(id)parent nestedCollection:(RLMResults *)collection;

@end