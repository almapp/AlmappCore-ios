//
//  ALMCampus.m
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMCampus.h"
#import "ALMOrganization.h"
#import "ALMResourceConstants.h"

@implementation ALMCampus

+ (NSString *)pluralForm {
    return @"campuses";
}

+ (NSString *)apiPluralForm {
    return [self pluralForm];
}

+ (NSString *)realmPluralForm {
    return [self pluralForm];
}

@end
