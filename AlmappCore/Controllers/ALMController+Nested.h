//
//  ALMController+Nested.h
//  AlmappCore
//
//  Created by Patricio López on 31-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMController.h"

@interface ALMController (Nested)

- (PMKPromise *)LOAD:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest;
- (PMKPromise *)LOAD:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest as:(NSString *)collectionName;

- (PMKPromise *)FETCH:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest;
- (PMKPromise *)FETCH:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest as:(NSString *)collectionName;
- (PMKPromise *)FETCH:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest as:(NSString *)collectionName belongsToAs:(NSString *)belongsToAlias;

@end
