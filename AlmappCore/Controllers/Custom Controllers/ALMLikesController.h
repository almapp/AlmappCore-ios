//
//  ALMLikesController.h
//  AlmappCore
//
//  Created by Patricio López on 15-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMCustomController.h"

@interface ALMLikesController : ALMCustomController

- (PMKPromise *)like:(ALMResource<ALMLikeable> *)likeable;
- (PMKPromise *)dislike:(ALMResource<ALMLikeable> *)likeable;

@end
