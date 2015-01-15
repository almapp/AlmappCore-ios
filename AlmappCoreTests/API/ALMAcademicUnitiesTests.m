//
//  ALMAcademicUnitiesTests.m
//  AlmappCore
//
//  Created by Patricio López on 14-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ALMResourcesTests.h"

@interface ALMAcademicUnitiesTests : ALMResourcesTests

@end

@implementation ALMAcademicUnitiesTests

- (void)testNaming {
    NSDictionary *expectedMatches = @{[ALMAcademicUnity singleForm] : @"AcademicUnity",
                                      [ALMAcademicUnity pluralForm] : @"AcademicUnities",
                                      [ALMAcademicUnity apiSingleForm] : @"academic_unity",
                                      [ALMAcademicUnity apiPluralForm] : @"academic_unities",
                                      [ALMAcademicUnity realmSingleForm] : @"academicUnity",
                                      [ALMAcademicUnity realmPluralForm] : @"academicUnities"
                                      };
    
    [self testNameMatching:expectedMatches];
}

@end
