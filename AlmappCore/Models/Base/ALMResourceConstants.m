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

NSString *const kAPolymorphicArea = @"area";
NSString *const kAPolymorphicAreaType = @"area_type";
NSString *const kAPolymorphicAreaID = @"area_id";

NSString *const kAPolymorphicHost = @"host";
NSString *const kAPolymorphicHostType = @"host_type";
NSString *const kAPolymorphicHostID = @"host_id";

NSString *const kAPolymorphicCommentable = @"commentable";
NSString *const kAPolymorphicCommentableType = @"commentable_type";
NSString *const kAPolymorphicCommentableID = @"commentable_id";

NSString *const kAPolymorphicLikeable = @"likeable";
NSString *const kAPolymorphicLikeableType = @"likeable_type";
NSString *const kAPolymorphicLikeableID = @"likeable_id";

NSString *const kAPolymorphicPostTargetable = @"target";
NSString *const kAPolymorphicPostTargetableType = @"target_type";
NSString *const kAPolymorphicPostTargetableID = @"target_id";

NSString *const kAPolymorphicPostPublisher = @"entity";
NSString *const kAPolymorphicPostPublisherType = @"entity_type";
NSString *const kAPolymorphicPostPublisherID = @"entity_id";

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

NSString *const kRPolymorphicPostTargetable = @"target";
NSString *const kRPolymorphicPostTargetableType = @"targetType";
NSString *const kRPolymorphicPostTargetableID = @"targetID";

NSString *const kRPolymorphicPostPublisher = @"entity";
NSString *const kRPolymorphicPostPublisherType = @"entityType";
NSString *const kRPolymorphicPostPublisherID = @"entityID";

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

NSString *const kAUser = @"user";
NSString *const kRUser = @"user";

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

NSString *const kALocalization = @"localization";
NSString *const kRLocalization = @"localization";

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

NSString *const kAEvent = @"event";
NSString *const kREvent = @"event";

NSString *const kAParticipants = @"participants";
NSString *const kRParticipants = @"participants";

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

#pragma mark - WebPages

NSString *const kAOwner = @"owner";
NSString *const kROwner = @"owner";

NSString *const kAPageType = @"page_type";
NSString *const kRPageType = @"pageType";

NSString *const kAIsAvailable = @"available";
NSString *const kRIsAvailable = @"isAvailable";

NSString *const kAIsSecureProtocol = @"secure_protocol";
NSString *const kRIsSecureProtocol = @"isSecureProtocol";

NSString *const kAIsLoginRequired = @"requires_login";
NSString *const kRIsLoginRequired = @"isLoginRequired";

NSString *const kAShouldOpenInBrowser = @"should_open_in_browser";
NSString *const kRShouldOpenInBrowser = @"shouldOpenInBrowser";

NSString *const kABaseUrl = @"base_url";
NSString *const kRBaseUrl = @"baseUrl";

NSString *const kAHomeUrl = @"home_url";
NSString *const kRHomeUrl = @"homeUrl";

#pragma mark - Posts

NSString *const kAContent = @"content";
NSString *const kRContent = @"content";

NSString *const kAShouldNotify = @"notify";
NSString *const kRShouldNotify = @"shouldNotify";

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

+ (NSString*)polymorphicATypeKey:(NSString*)polymorphicResource {
    return [NSString stringWithFormat:@"%@_type", polymorphicResource];
}

+ (NSString*)polymorphicAIDKey:(NSString*)polymorphicResource {
    return [NSString stringWithFormat:@"%@_id", polymorphicResource];
}

+ (NSString*)polymorphicRTypeKey:(NSString*)polymorphicResource {
    return [NSString stringWithFormat:@"%@Type", polymorphicResource];
}

+ (NSString*)polymorphicRIDpeKey:(NSString*)polymorphicResource {
    return [NSString stringWithFormat:@"%@ID", polymorphicResource];
}

@end
