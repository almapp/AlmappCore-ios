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

extern NSString *const kRPolymorphicArea;
extern NSString *const kRPolymorphicAreaType;
extern NSString *const kRPolymorphicAreaID;

extern NSString *const kRPolymorphicHost;
extern NSString *const kRPolymorphicHostType;
extern NSString *const kRPolymorphicHostID;

extern NSString *const kRPolymorphicCommentable;
extern NSString *const kRPolymorphicCommentableType;
extern NSString *const kRPolymorphicCommentableID;

#pragma mark - Basics

extern NSString *const kAResourceID;
extern NSString *const kRResourceID;

extern NSString *const kAIdentifier;
extern NSString *const kRIdentifier;

extern NSString *const kAUpdatedAt;
extern NSString *const kRUpdatedAt;

extern NSString *const kACreatedAt;
extern NSString *const kRCreatedAt;

extern NSString *const kAName;
extern NSString *const kRName;

extern NSString *const kAShortName;
extern NSString *const kRShortName;

extern NSString *const kAAbbreviation;
extern NSString *const kRAbbreviation;

extern NSString *const kATitle;
extern NSString *const kRTitle;

extern NSString *const kAAddress;
extern NSString *const kRAddress;

extern NSString *const kAUsername;
extern NSString *const kRUsername;

extern NSString *const kAEmail;
extern NSString *const kREmail;

extern NSString *const kAFindeable;
extern NSString *const kRFindeable;

extern NSString *const kAURL;
extern NSString *const kRURL;

extern NSString *const kAFacebookURL;
extern NSString *const kRFacebookURL;

extern NSString *const kATwitterURL;
extern NSString *const kRTwitterURL;

extern NSString *const kAPhone;
extern NSString *const kRPhone;

extern NSString *const kAInformation;
extern NSString *const kRInformation;

#pragma mark - Users

extern NSString *const kALastSeen;
extern NSString *const kRLastSeen;

extern NSString *const kAMale;
extern NSString *const kRMale;

extern NSString *const kACountry;
extern NSString *const kRCountry;

extern NSString *const kAStudentID;
extern NSString *const kRStudentID;

#pragma mark - Places

extern NSString *const kAIsService;
extern NSString *const kRIsService;

extern NSString *const kAZoom;
extern NSString *const kRZoom;

extern NSString *const kAAngle;
extern NSString *const kRAngle;

extern NSString *const kATilt;
extern NSString *const kRTilt;

extern NSString *const kALatitude;
extern NSString *const kRLatitude;

extern NSString *const kALongitude;
extern NSString *const kRLongitude;

extern NSString *const kAFloor;
extern NSString *const kRFloor;

#pragma mark - Events

extern NSString *const kAIsPrivate;
extern NSString *const kRIsPrivate;

extern NSString *const kAPublishDate;
extern NSString *const kRPublishDate;

extern NSString *const kAFromDate;
extern NSString *const kRFromDate;

extern NSString *const kAToDate;
extern NSString *const kRToDate;

#pragma mark - Social

extern NSString *const kAComment;
extern NSString *const kRComment;

extern NSString *const kAIsHidden;
extern NSString *const kRIsHidden;

extern NSString *const kAIsAnonymous;
extern NSString *const kRIsAnonymous;

#pragma mark - Academic

extern NSString *const kACurriculumURL;
extern NSString *const kRCurriculumURL;

/*
extern NSString *const kA;
extern NSString *const kR;

extern NSString *const kA;
extern NSString *const kR;

extern NSString *const kA;
extern NSString *const kR;

extern NSString *const kA;
extern NSString *const kR;

*/

@interface ALMResourceConstants : NSObject

@end
