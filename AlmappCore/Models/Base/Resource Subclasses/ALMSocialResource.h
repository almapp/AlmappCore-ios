//
//  ALMSocialResource.h
//  AlmappCore
//
//  Created by Patricio López on 19-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"
#import "ALMLikeable.h"
#import "ALMCommentable.h"

@interface ALMSocialResource : ALMResource <ALMLikeable, ALMCommentable>

@end
