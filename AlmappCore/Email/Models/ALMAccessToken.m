//
//  ALMAccessToken.m
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMAccessToken.h"

@implementation ALMAccessToken

- (BOOL)isExpired {
    return [self.expiresIn compare:[NSDate date]] == NSOrderedAscending;
}

@end
