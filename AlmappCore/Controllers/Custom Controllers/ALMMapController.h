//
//  ALMMapController.h
//  AlmappCore
//
//  Created by Patricio López on 16-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMCustomController.h"

@interface ALMMapController : ALMCustomController

- (PMKPromise *)fetchMaps;



@end
