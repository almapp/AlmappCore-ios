//
//  ALMArea.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMSocialResource.h"
#import "ALMPlace.h"
#import "ALMMapable.h"
#import "ALMPostTargetable.h"
#import "ALMPostPublisher.h"
#import "ALMEventHost.h"

@interface ALMArea : ALMSocialResource <ALMMapable, ALMPostTargetable, ALMPostPublisher, ALMEventHost>

@property NSString *name;
@property NSString *shortName;
@property NSString *abbreviation;
@property NSString *address;
@property NSString *bannerOriginalPath;
@property NSString *bannerSmallPath;
@property RLMArray<ALMPlace> *places;
@property NSString *email;
@property NSString *url;
@property NSString *facebookUrl;
@property NSString *twitterUrl;
@property NSString *phoneString;
@property NSString *information;

@property NSDate *updatedAt;
@property NSDate *createdAt;

- (RLMResults *)placesWithCategory:(ALMCategoryType)categoryType;

@end
RLM_ARRAY_TYPE(ALMArea)