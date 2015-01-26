//
//  ALMScheduleItem.m
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMScheduleItem.h"
#import "ALMSection.h"
#import "ALMPlace.h"
#import "ALMCampus.h"
#import "ALMResourceConstants.h"

@implementation ALMScheduleItem

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kAClassType]          : kRClassType,
             [self jatt:@"schedule_module_id"] : @"scheduleModuleID",
             [self jatt:@"place_name"]         : @"placeName",
             [self jatt:@"campus_name"]     : @"campusName",
             [self jatt:@"place_id"]         : @"placeID",
             [self jatt:@"campus_id"]     : @"campusID",
             [self jatt:kAUpdatedAt]        : kRUpdatedAt,
             [self jatt:kACreatedAt]        : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kAClassType                         : kRDefaultNullString,
             @"placeName"                     : kRDefaultNullString,
             @"campusName"                  : kRDefaultNullString,
             @"placeID"                     : @0,
             @"campusID"                     : @0,
             @"scheduleModuleID"            : @0,
             kRUpdatedAt                        : [NSDate defaultDate],
             kRCreatedAt                        : [NSDate defaultDate]
             };
}

+ (NSString *)apiSingleForm {
    return @"schedule_item";
}

+ (NSString *)realmSingleForm {
    return @"scheduleItem";
}

- (ALMSection *)section {
    return [self linkingObjectsOfClass:[ALMSection className] forProperty:[self realmPluralForm]].firstObject;
}

- (ALMScheduleModule *)scheduleModule {
    return (self.scheduleModuleID != 0) ? [ALMScheduleModule objectInRealm:self.realm withID:self.scheduleModuleID] : nil;
}

- (ALMCampus *)campus {
    return (self.campusID != 0) ? [ALMCampus objectInRealm:self.realm withID:self.campusID] : nil;
}

- (ALMPlace *)place {
    return (self.placeID != 0) ? [ALMPlace objectInRealm:self.realm withID:self.placeID] : nil;
}

@end
