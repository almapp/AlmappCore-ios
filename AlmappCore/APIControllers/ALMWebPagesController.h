//
//  ALMWebPagesController.h
//  AlmappCore
//
//  Created by Patricio López on 12-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMController.h"
#import "ALMWebPage.h"

@interface ALMWebPagesController : ALMController

- (ALMWebPage*)webPageWithIdentifier:(NSString*)identifier;

@end
