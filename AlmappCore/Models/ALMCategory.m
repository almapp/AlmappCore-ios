//
//  ALMCategory.m
//  AlmappCore
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCategory.h"
#import "ALMResourceConstants.h"

@implementation ALMCategory

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{kACategory : kRCategory};
}

+ (NSString *)primaryKey {
    return kRCategory;
}

+ (NSDictionary *)defaultPropertyValues {
    return @{kRCategory : @(ALMCategoryTypeNone)};
}

+ (NSValueTransformer *)categoryJSONTransformer {
    NSDictionary *mapping = @{
                              @"area" : @(ALMCategoryTypeArea),
                              @"classroom" : @(ALMCategoryTypeClassroom),
                              @"bath_men" : @(ALMCategoryTypeBathMen),
                              @"bath_women" : @(ALMCategoryTypeBathWomen),
                              @"trash" : @(ALMCategoryTypeTrash),
                              @"park_bicycle" : @(ALMCategoryTypeParkBicycle),
                              @"park_car" : @(ALMCategoryTypeParkCar),
                              @"study" : @(ALMCategoryTypeStudy),
                              @"food_lunch" : @(ALMCategoryTypeFoodLunch),
                              @"food_stand" : @(ALMCategoryTypeFoodStand),
                              @"food_machine" : @(ALMCategoryTypeFoodMachine),
                              @"printer" : @(ALMCategoryTypePrinter),
                              @"computers" : @(ALMCategoryTypeComputers),
                              @"photocopy" : @(ALMCategoryTypePhotocopy),
                              @"cash_machine" : @(ALMCategoryTypeCashMachine),
                              @"bank" : @(ALMCategoryTypeBank),
                              @"library" : @(ALMCategoryTypeLibrary),
                              @"other" : @(ALMCategoryTypeOther)
                              };
    
    return [MCJSONValueTransformer valueTransformerWithMappingDictionary:mapping];
}

@end

    