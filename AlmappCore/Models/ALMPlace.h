//
//  ALMPlace.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <CoreGraphics/CGBase.h>

#import "ALMSocialResource.h"
#import "ALMCategory.h"

@class ALMArea;

@interface ALMPlace : ALMSocialResource

@property NSString *name;
@property NSString *identifier;
@property NSString *areaType; // Owner type
@property long long areaID;   // Owner ID (no polymorhpic assosiations)
@property CGFloat zoom;
@property CGFloat angle;
@property CGFloat tilt;
@property CGFloat latitude;
@property CGFloat longitude;
@property NSString *floor;
@property NSString *information;
@property RLMArray<ALMCategory> *categories;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (void)setArea:(ALMArea*)area;
- (ALMArea*)area;

@end
RLM_ARRAY_TYPE(ALMPlace)

