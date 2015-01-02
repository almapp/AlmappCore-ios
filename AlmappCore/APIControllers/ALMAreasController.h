//
//  ALMAreasController.h
//  AlmappCore
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMController.h"
#import "ALMArea.h"

@interface ALMAreasController : ALMController

- (NSArray*)placesForArea:(ALMArea*)area;
- (AFHTTPRequestOperation*)updatePlacesForArea:(ALMArea*)area parameters:(id)parameters onSuccess:(void (^)(NSArray *result))onSuccess onFailure:(void (^)(NSError *error))onFailure;


@end
