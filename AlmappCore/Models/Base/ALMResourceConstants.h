//
//  ALMResourceConstants.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Defaults

extern NSString *const kRDefaultNullString;
extern NSString *const kRDefaultPolymorphicType;

#pragma mark - Polymorphic

extern NSString *const kRPolymorphicAreaType;
extern NSString *const kRPolymorphicAreaID;

extern NSString *const kRPolymorphicHostType;
extern NSString *const kRPolymorphicHostID;

#pragma mark - Basics

extern NSString *const kRResourceID;
extern NSString *const kAResourceID;

extern NSString *const kRIdentifier;
extern NSString *const kAIdentifier;

extern NSString *const kRUpdatedAt;
extern NSString *const kAUpdatedAt;

extern NSString *const kRCreatedAt;
extern NSString *const kACreatedAt;

extern NSString *const kRName;
extern NSString *const kAName;

extern NSString *const kRShortName;
extern NSString *const kAShortName;

extern NSString *const kRAbbreviation;
extern NSString *const kAAbbreviation;

extern NSString *const kRTitle;
extern NSString *const kATitle;

extern NSString *const kRAddress;
extern NSString *const kAAddress;

extern NSString *const kRUsername;
extern NSString *const kAUsername;

extern NSString *const kREmail;
extern NSString *const kAEmail;

extern NSString *const kRFindeable;
extern NSString *const kAFindeable;

extern NSString *const kRURL;
extern NSString *const kAURL;

extern NSString *const kRFacebookURL;
extern NSString *const kAFacebookURL;

extern NSString *const kRTwitterURL;
extern NSString *const kATwitterURL;

extern NSString *const kRPhone;
extern NSString *const kAPhone;

extern NSString *const kRInformation;
extern NSString *const kAInformation;

#pragma mark - Users

extern NSString *const kRLastSeen;
extern NSString *const kALastSeen;

extern NSString *const kRMale;
extern NSString *const kAMale;

extern NSString *const kRCountry;
extern NSString *const kACountry;

extern NSString *const kRStudentID;
extern NSString *const kAStudentID;

#pragma mark - Places

extern NSString *const kRIsService;
extern NSString *const kAIsService;

extern NSString *const kRZoom;
extern NSString *const kAZoom;

extern NSString *const kRAngle;
extern NSString *const kAAngle;

extern NSString *const kRTilt;
extern NSString *const kATilt;

extern NSString *const kRLatitude;
extern NSString *const kALatitude;

extern NSString *const kRLongitude;
extern NSString *const kALongitude;

extern NSString *const kRFloor;
extern NSString *const kAFloor;

#pragma mark - Events

extern NSString *const kRIsPrivate;
extern NSString *const kAIsPrivate;

extern NSString *const kRPublishDate;
extern NSString *const kAPublishDate;

extern NSString *const kRFromDate;
extern NSString *const kAFromDate;

extern NSString *const kRToDate;
extern NSString *const kAToDate;

#pragma mark - Academic

extern NSString *const kRCurriculumURL;
extern NSString *const kACurriculumURL;

/*
extern NSString *const kR;
extern NSString *const kA;

extern NSString *const kR;
extern NSString *const kA;

extern NSString *const kR;
extern NSString *const kA;

extern NSString *const kR;
extern NSString *const kA;

*/

@interface ALMResourceConstants : NSObject

@end
