//
//  ALMResourceConstants.h
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Configuration

extern NSString *const kDateFormat;

#pragma mark - Defaults

extern NSString *const kRDefaultNullString;
extern NSString *const kRDefaultPolymorphicType;
extern NSNumber *kRDefaultPolymorphicID;
extern NSString *const kRDefaultUnknownFloor;
extern NSString *const kRDefaultTimeString;

#pragma mark - Polymorphic

extern NSString *const kAPolymorphicArea;
extern NSString *const kAPolymorphicAreaType;
extern NSString *const kAPolymorphicAreaID;

extern NSString *const kAPolymorphicHost;
extern NSString *const kAPolymorphicHostType;
extern NSString *const kAPolymorphicHostID;

extern NSString *const kAPolymorphicCommentable;
extern NSString *const kAPolymorphicCommentableType;
extern NSString *const kAPolymorphicCommentableID;

extern NSString *const kAPolymorphicLikeable;
extern NSString *const kAPolymorphicLikeableType;
extern NSString *const kAPolymorphicLikeableID;

extern NSString *const kAPolymorphicPostTargetable;
extern NSString *const kAPolymorphicPostTargetableType;
extern NSString *const kAPolymorphicPostTargetableID;

extern NSString *const kAPolymorphicPostPublisher;
extern NSString *const kAPolymorphicPostPublisherType;
extern NSString *const kAPolymorphicPostPublisherID;

extern NSString *const kAPolymorphicConversable;
extern NSString *const kAPolymorphicConversableType;
extern NSString *const kAPolymorphicConversableID;


extern NSString *const kRPolymorphicArea;
extern NSString *const kRPolymorphicAreaType;
extern NSString *const kRPolymorphicAreaID;

extern NSString *const kRPolymorphicHost;
extern NSString *const kRPolymorphicHostType;
extern NSString *const kRPolymorphicHostID;

extern NSString *const kRPolymorphicCommentable;
extern NSString *const kRPolymorphicCommentableType;
extern NSString *const kRPolymorphicCommentableID;

extern NSString *const kRPolymorphicLikeable;
extern NSString *const kRPolymorphicLikeableType;
extern NSString *const kRPolymorphicLikeableID;

extern NSString *const kRPolymorphicPostTargetable;
extern NSString *const kRPolymorphicPostTargetableType;
extern NSString *const kRPolymorphicPostTargetableID;

extern NSString *const kRPolymorphicPostPublisher;
extern NSString *const kRPolymorphicPostPublisherType;
extern NSString *const kRPolymorphicPostPublisherID;

extern NSString *const kRPolymorphicConversable;
extern NSString *const kRPolymorphicConversableType;
extern NSString *const kRPolymorphicConversableID;

#pragma mark - Basics

extern NSString *const kAResourceID;
extern NSString *const kRResourceID;

extern NSString *const kAIdentifier;
extern NSString *const kRIdentifier;

extern NSString *const kAInitials;
extern NSString *const kRInitials;

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

extern NSString *const kAUser;
extern NSString *const kRUser;

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

extern NSString *const kAImagenOriginalPath;
extern NSString *const kRImagenOriginalPath;

extern NSString *const kAImagenThumbPath;
extern NSString *const kRImagenThumbPath;

#pragma mark - Users

extern NSString *const kASession;
extern NSString *const kRSession;

extern NSString *const kALastSignIn;
extern NSString *const kRLastSignIn;

extern NSString *const kACurrentSignIn;
extern NSString *const kRCurrentSignIn;

extern NSString *const kAMale;
extern NSString *const kRMale;

extern NSString *const kACountry;
extern NSString *const kRCountry;

extern NSString *const kAStudentID;
extern NSString *const kRStudentID;

#pragma mark - Places

extern NSString *const kALocalization;
extern NSString *const kRLocalization;

extern NSString *const kACategory;
extern NSString *const kRCategory;

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

extern NSString *const kABannerOriginalPath;
extern NSString *const kRBannerOriginalPath;

extern NSString *const kABannerSmallPath;
extern NSString *const kRBannerSmallPath;

#pragma mark - Events

extern NSString *const kAEvent;
extern NSString *const kREvent;

extern NSString *const kAParticipants;
extern NSString *const kRParticipants;

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

extern NSString *const kAValuation;
extern NSString *const kRValuation;

extern NSString *const kAIsFlagged;
extern NSString *const kRIsFlagged;

extern NSString *const kALikesCount;
extern NSString *const kRLikesCount;

extern NSString *const kADislikesCount;
extern NSString *const kRDislikesCount;

extern NSString *const kACommentsCount;
extern NSString *const kRCommentsCount;

#pragma mark - Academic

extern NSString *const kRStudents;

extern NSString *const kASections;
extern NSString *const kRSections;

extern NSString *const kAClassType;
extern NSString *const kRClassType;

extern NSString *const kAYear;
extern NSString *const kRYear;

extern NSString *const kAPeriod;
extern NSString *const kRPeriod;

extern NSString *const kASectionNumber;
extern NSString *const kRSectionNumber;

extern NSString *const kACredits;
extern NSString *const kRCredits;

extern NSString *const kAVacancy;
extern NSString *const kRVacancy;

extern NSString *const kADay;
extern NSString *const kRDay;

extern NSString *const kABlock;
extern NSString *const kRBlock;

extern NSString *const kAStartTimeHour;
extern NSString *const kRStartTimeHour;

extern NSString *const kAStartTimeMinute;
extern NSString *const kRStartTimeMinute;

extern NSString *const kAEndTimeHour;
extern NSString *const kREndTimeHour;

extern NSString *const kAEndTimeMinute;
extern NSString *const kREndTimeMinute;

#pragma mark - Webpages

extern NSString *const kAOwner;
extern NSString *const kROwner;

extern NSString *const kAPageType;
extern NSString *const kRPageType;

extern NSString *const kAIsAvailable;
extern NSString *const kRIsAvailable;

extern NSString *const kAIsSecureProtocol;
extern NSString *const kRIsSecureProtocol;

extern NSString *const kAIsLoginRequired;
extern NSString *const kRIsLoginRequired;

extern NSString *const kAShouldOpenInBrowser;
extern NSString *const kRShouldOpenInBrowser;

extern NSString *const kALoginUrl;
extern NSString *const kRLoginUrl;

extern NSString *const kAHomeUrl;
extern NSString *const kRHomeUrl;

extern NSString *const kAIconOriginalPath;
extern NSString *const kRIconOriginalPath;

extern NSString *const kABackgroundOriginalPath;
extern NSString *const kRBackgroundOriginalPath;

#pragma mark - Posts

extern NSString *const kAContent;
extern NSString *const kRContent;

extern NSString *const kAShouldNotify;
extern NSString *const kRShouldNotify;

#pragma mark - Groups

extern NSString *const kASubscribers;
extern NSString *const kRSubscribers;

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

+ (NSString*)polymorphicATypeKey:(NSString*)polymorphicResource;
+ (NSString*)polymorphicAIDKey:(NSString*)polymorphicResource;
+ (NSString*)polymorphicRTypeKey:(NSString*)polymorphicResource;
+ (NSString*)polymorphicRIDpeKey:(NSString*)polymorphicResource;

@end
