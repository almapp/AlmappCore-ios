//
//  ALMUser.m
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMUser.h"
#import "ALMResourceConstants.h"
#import "ALMSection.h"
#import "ALMEvent.h"
#import "ALMGroup.h"

@implementation ALMUser

@synthesize publishedPosts = _publishedPosts;

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kAName]             : kRName,
             [self jatt:kAUsername]         : kRUsername,
             [self jatt:kAEmail]            : kREmail,
             [self jatt:kAMale]             : kRMale,
             [self jatt:kAStudentID]        : kRStudentID,
             [self jatt:kACountry]          : kRCountry,
             [self jatt:kAFindeable]        : kRFindeable,
             [self jatt:kAImagenMediumPath] : kRImagenMediumPath,
             [self jatt:kAImagenThumbPath]  : kRImagenThumbPath,
             [self jatt:kALastSignIn]       : kRLastSignIn,
             [self jatt:kACurrentSignIn]    : kRCurrentSignIn,
             [self jatt:kAUpdatedAt]        : kRUpdatedAt,
             [self jatt:kACreatedAt]        : kRCreatedAt
             };
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRName                       : kRDefaultNullString,
             kRMale                       : @YES,
             kRStudentID                  : kRDefaultNullString,
             kRCountry                    : kRDefaultNullString,
             kRFindeable                  : @YES,
             kRImagenMediumPath           : kRDefaultNullString,
             kRImagenThumbPath            : kRDefaultNullString,
             kRLastSignIn                 : [NSDate defaultDate],
             kRCurrentSignIn              : [NSDate defaultDate],
             kRUpdatedAt                  : [NSDate defaultDate],
             kRCreatedAt                  : [NSDate defaultDate]
             };
}

+ (NSDictionary *)JSONNestedResourceCollectionInboundMappingDictionary {
    return @{[ALMCareer apiPluralForm] : [ALMCareer realmPluralForm]};
}

+ (Class)propertyTypeForKRConstant:(NSString *)kr {
    if([kr isEqualToString:[ALMCareer realmPluralForm]]) {
        return [ALMCareer class];
    }
    else {
        return [super propertyTypeForKRConstant:kr];
    }
}

- (RLMResults *)sectionsInYear:(short)year period:(short)period {
    NSString *query = [NSString stringWithFormat:@"%@ = %hd AND %@ = %hd", kRYear, year, kRPeriod, period];
    return [self.sections objectsWhere:query];
}

- (RLMResults *)coursesInYear:(short)year period:(short)period {
    NSMutableArray *ids = [NSMutableArray array];
    for (ALMSection *section in [self sectionsInYear:year period:period]) {
        [ids addObject:@(section.course.resourceID)];
    }
    NSString *query = [NSString stringWithFormat:@"%@ IN %@", kRResourceID, [ids toRealmStringArray]];
    return [ALMCourse objectsInRealm:self.realm where:query];
}

- (RLMResults *)teachersInYear:(short)year period:(short)period {
    NSMutableArray *ids = [NSMutableArray array];
    for (ALMSection *section in [self sectionsInYear:year period:period]) {
        [ids addObjectsFromArray:[section.teachers select:kRResourceID]];
    }
    NSString *query = [NSString stringWithFormat:@"%@ IN %@", kRResourceID, [ids toRealmStringArray]];
    return [ALMTeacher objectsInRealm:self.realm where:query];
}
            

@end
