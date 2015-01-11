//
//  ALMResourceConstants.m
//  AlmappCore
//
//  Created by Patricio López on 04-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceConstants.h"

#pragma mark - Initializer

__attribute__((constructor))
static void InitGlobalNumber() {
    kRDefaultPolymorphicID = [NSNumber numberWithInteger:0];
}

#pragma mark - Defaults

NSString *const kRDefaultNullString = @"";
NSString *const kRDefaultPolymorphicType = @"NONE";
NSNumber *kRDefaultPolymorphicID;
NSString *const kRDefaultUnknownFloor = @"?";

#pragma mark - Polymorphic

NSString *const kRPolymorphicArea = @"area";
NSString *const kRPolymorphicAreaType = @"areaType";
NSString *const kRPolymorphicAreaID = @"areaID";

NSString *const kRPolymorphicHost = @"host";
NSString *const kRPolymorphicHostType = @"hostType";
NSString *const kRPolymorphicHostID = @"hostID";

NSString *const kRPolymorphicCommentable = @"commentable";
NSString *const kRPolymorphicCommentableType = @"commentableType";
NSString *const kRPolymorphicCommentableID = @"commentableID";

NSString *const kRPolymorphicLikeable = @"likeable";
NSString *const kRPolymorphicLikeableType = @"likeableType";
NSString *const kRPolymorphicLikeableID = @"likeableID";

#pragma mark - Basics

NSString *const kAResourceID = @"id";
NSString *const kRResourceID = @"resourceID";

NSString *const kAIdentifier = @"identifier";
NSString *const kRIdentifier = @"identifier";

NSString *const kAUpdatedAt = @"updated_at";
NSString *const kRUpdatedAt = @"updatedAt";

NSString *const kACreatedAt = @"created_at";
NSString *const kRCreatedAt = @"createdAt";

NSString *const kAName = @"name";
NSString *const kRName = @"name";

NSString *const kAShortName = @"short_name";
NSString *const kRShortName = @"shortName";

NSString *const kAAbbreviation = @"abbreviation";
NSString *const kRAbbreviation = @"abbreviation";

NSString *const kATitle = @"title";
NSString *const kRTitle = @"title";

NSString *const kAAddress = @"address";
NSString *const kRAddress = @"address";

NSString *const kAUsername = @"username";
NSString *const kRUsername = @"username";

NSString *const kAEmail = @"email";
NSString *const kREmail = @"email";

NSString *const kAFindeable = @"findeable";
NSString *const kRFindeable = @"isFindeable";

NSString *const kAURL = @"url";
NSString *const kRURL = @"url";

NSString *const kAFacebookURL = @"facebook";
NSString *const kRFacebookURL = @"facebookUrl";

NSString *const kATwitterURL = @"twitter";
NSString *const kRTwitterURL = @"twitterUrl";

NSString *const kAPhone = @"phone";
NSString *const kRPhone = @"phoneString";

NSString *const kAInformation = @"information";
NSString *const kRInformation = @"information";

#pragma mark - Users

NSString *const kALastSeen = @"last_seen";
NSString *const kRLastSeen = @"lastSeen";

NSString *const kAMale = @"male";
NSString *const kRMale = @"isMale";

NSString *const kACountry = @"country";
NSString *const kRCountry = @"country";

NSString *const kAStudentID = @"student_id";
NSString *const kRStudentID = @"studentID";

#pragma mark - Places

NSString *const kAIsService = @"service";
NSString *const kRIsService = @"isService";

NSString *const kAZoom = @"zoom";
NSString *const kRZoom = @"zoom";

NSString *const kAAngle = @"angle";
NSString *const kRAngle = @"angle";

NSString *const kATilt = @"tilt";
NSString *const kRTilt = @"tilt";

NSString *const kALatitude = @"latitude";
NSString *const kRLatitude = @"latitude";

NSString *const kALongitude = @"longitude";
NSString *const kRLongitude = @"longitude";

NSString *const kAFloor = @"floor";
NSString *const kRFloor = @"floor";

#pragma mark - Events

NSString *const kAIsPrivate = @"private";
NSString *const kRIsPrivate = @"isPrivate";

NSString *const kAPublishDate = @"publish_date";
NSString *const kRPublishDate = @"publishDate";

NSString *const kAFromDate = @"from_date";
NSString *const kRFromDate = @"fromDate";

NSString *const kAToDate = @"to_date";
NSString *const kRToDate = @"toDate";

#pragma mark - Social

NSString *const kAComment = @"comment";
NSString *const kRComment = @"comment";

NSString *const kAIsHidden = @"hidden";
NSString *const kRIsHidden = @"isHidden";

NSString *const kAIsAnonymous = @"anonymous";
NSString *const kRIsAnonymous = @"isAnonymous";

NSString *const kAValuation = @"valuation";
NSString *const kRValuation = @"valuation";

#pragma mark - Academic

NSString *const kACurriculumURL = @"curriculum_url";
NSString *const kRCurriculumURL = @"curriculumUrl";

/*
extern NSString *const kA = @"";
extern NSString *const kR = @"";

extern NSString *const kA = @"";
extern NSString *const kR;

extern NSString *const kA;
extern NSString *const kR;

extern NSString *const kA;
extern NSString *const kR;

*/

@implementation ALMResourceConstants

@end
