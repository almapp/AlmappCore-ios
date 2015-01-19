//
//  ALMPlace.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMSocialResource.h"

@class ALMArea;

@interface ALMPlace : ALMSocialResource

@property NSString *name;
@property NSString *identifier;
@property BOOL isService;
@property NSString *areaType; // Owner type
@property long long areaID;   // Owner ID (no polymorhpic assosiations)
@property float zoom;
@property float angle;
@property float tilt;
@property float latitude;
@property float longitude;
@property NSString *floor;
@property NSString *information;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (void)setArea:(ALMArea*)area;
- (ALMArea*)area;

@end
RLM_ARRAY_TYPE(ALMPlace)