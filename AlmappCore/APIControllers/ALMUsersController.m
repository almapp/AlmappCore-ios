//
//  ALMUsersController.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMUsersController.h"

@implementation ALMUsersController

-(RLMObject *)updateInRealm:(RLMRealm *)realm resource:(NSDictionary *)resource {
    return [ALMUser createOrUpdateInRealm:realm withJSONDictionary:resource];
}

-(NSString *)resourceSingleName {
    return @"user";
}

@end
