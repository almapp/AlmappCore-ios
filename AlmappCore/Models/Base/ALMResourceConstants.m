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

#pragma mark - Configuration

NSString *const kDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

#pragma mark - Defaults

NSString *const kRDefaultNullString = @"";
NSString *const kRDefaultPolymorphicType = @"NONE";
NSNumber *kRDefaultPolymorphicID;
NSString *const kRDefaultUnknownFloor = @"?";
NSString *const kRDefaultTimeString = @"00:00";

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

NSString *const kAPolymorphicConversable = @"conversable";
NSString *const kAPolymorphicConversableType = @"conversable_type";
NSString *const kAPolymorphicConversableID = @"conversable_id";


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

NSString *const kRPolymorphicConversable = @"conversable";
NSString *const kRPolymorphicConversableType = @"conversableType";
NSString *const kRPolymorphicConversableID = @"conversableID";

#pragma mark - Basics

NSString *const kAResourceID = @"id";
NSString *const kRResourceID = @"resourceID";

NSString *const kAIdentifier = @"identifier";
NSString *const kRIdentifier = @"identifier";

NSString *const kAInitials = @"initials";
NSString *const kRInitials = @"initials";

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

NSString *const kAImagenOriginalPath = @"avatar.original";
NSString *const kRImagenOriginalPath = @"imageOriginalPath";

NSString *const kAImagenThumbPath = @"avatar.thumb";
NSString *const kRImagenThumbPath = @"imageThumbPath";

#pragma mark - Users

NSString *const kASession = @"session";
NSString *const kRSession = @"session";

NSString *const kALastSignIn = @"last_sign_in_at";
NSString *const kRLastSignIn = @"lastSignIn";

NSString *const kACurrentSignIn = @"current_sign_in_at";
NSString *const kRCurrentSignIn = @"currentSignIn";

NSString *const kAMale = @"male";
NSString *const kRMale = @"isMale";

NSString *const kACountry = @"country";
NSString *const kRCountry = @"country";

NSString *const kAStudentID = @"student_id";
NSString *const kRStudentID = @"studentID";

#pragma mark - Places

NSString *const kALocalization = @"localization";
NSString *const kRLocalization = @"localization";

NSString *const kACategory = @"category";
NSString *const kRCategory = @"category";

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

NSString *const kABannerOriginalPath = @"banner.original";
NSString *const kRBannerOriginalPath = @"bannerOriginalPath";

NSString *const kABannerSmallPath = @"banner.small";
NSString *const kRBannerSmallPath = @"bannerSmallPath";

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

NSString *const kAIsFlagged = @"flagged";
NSString *const kRIsFlagged = @"isFlagged";

NSString *const kALikesCount = @"likes_count";
NSString *const kRLikesCount = @"likesCount";

NSString *const kADislikesCount = @"dislikes_count";
NSString *const kRDislikesCount = @"dislikesCount";

NSString *const kACommentsCount = @"comments_count";
NSString *const kRCommentsCount = @"commentsCount";

#pragma mark - Academic

NSString *const kRStudents = @"students";

NSString *const kASections = @"sections";
NSString *const kRSections = @"sections";

NSString *const kAClassType = @"class_type";
NSString *const kRClassType = @"classType";

NSString *const kAYear = @"year";
NSString *const kRYear = @"year";

NSString *const kAPeriod = @"period";
NSString *const kRPeriod = @"period";

NSString *const kASectionNumber = @"number";
NSString *const kRSectionNumber = @"number";

NSString *const kACredits = @"credits";
NSString *const kRCredits = @"credits";

NSString *const kAVacancy = @"vacancy";
NSString *const kRVacancy = @"vacancy";

NSString *const kADay = @"day";
NSString *const kRDay = @"dayNumber";

NSString *const kABlock = @"block";
NSString *const kRBlock = @"block";

NSString *const kAStartTimeHour = @"start.hour";
NSString *const kRStartTimeHour = @"startHour";

NSString *const kAStartTimeMinute = @"start.minute";
NSString *const kRStartTimeMinute = @"startMinute";

NSString *const kAEndTimeHour = @"end.hour";
NSString *const kREndTimeHour = @"endHour";

NSString *const kAEndTimeMinute = @"end.minute";
NSString *const kREndTimeMinute = @"endMinute";

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

NSString *const kALoginUrl = @"login_url";
NSString *const kRLoginUrl = @"loginUrl";

NSString *const kAHomeUrl = @"home_url";
NSString *const kRHomeUrl = @"homeUrl";

NSString *const kAIconOriginalPath = @"icon.original";
NSString *const kRIconOriginalPath = @"iconOriginalPath";

NSString *const kABackgroundOriginalPath = @"background.original";
NSString *const kRBackgroundOriginalPath = @"backgroundOriginalPath";

#pragma mark - Posts

NSString *const kAContent = @"content";
NSString *const kRContent = @"content";

NSString *const kAShouldNotify = @"notify";
NSString *const kRShouldNotify = @"shouldNotify";

#pragma mark - Groups

NSString *const kASubscribers = @"subscribers";
NSString *const kRSubscribers = @"subscribers";

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
