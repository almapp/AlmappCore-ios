//
//  ALMPlace.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMResource.h"

@interface ALMPlace : ALMResource

@property NSString *name;
@property NSString *identifier;
@property BOOL isService;
@property (readonly) NSArray *areas;
@property float zoom;
@property float angle;
@property float tilt;
@property float latitude;
@property float longitude;
@property NSString *floor;
@property NSString *information;

@end
RLM_ARRAY_TYPE(ALMPlace)