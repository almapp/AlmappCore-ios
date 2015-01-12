//
//  ALMWebPagesController.m
//  AlmappCore
//
//  Created by Patricio López on 12-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMWebPagesController.h"
#import "ALMResourceConstants.h"

@implementation ALMWebPagesController

- (ALMWebPage *)webPageWithIdentifier:(NSString *)identifier {
    return [ALMWebPage objectsInRealm:[self requestRealm] where:[ NSString stringWithFormat:@"%@ = %@", kRIdentifier, identifier]].firstObject;
}

@end
