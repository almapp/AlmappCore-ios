//
//  ALMScheduleModule.h
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResource.h"

typedef NS_ENUM(NSUInteger, ALMScheduleDay) {
    ALMScheduleDayMonday = 1,
    ALMScheduleDayTuesday,
    ALMScheduleDayWednesday,
    ALMScheduleDayThursday,
    ALMScheduleDayFriday,
    ALMScheduleDaySaturday,
    ALMScheduleDaySunday
};

@interface ALMScheduleModule : ALMResource

#pragma mark - Schedule Modules

+ (instancetype)moduleForDay:(int)day block:(int)block;
+ (instancetype)moduleForDay:(int)day block:(int)block inRealm:(RLMRealm*)realm;

+ (instancetype)nextModuleOf:(ALMScheduleModule*)module;
+ (instancetype)previousModuleOf:(ALMScheduleModule*)module;

+ (instancetype)firstModuleOfDay:(ALMScheduleDay)day;
+ (instancetype)firstModuleOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm;
+ (instancetype)lastModuleOfDay:(ALMScheduleDay)day;
+ (instancetype)lastModuleOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm;

- (instancetype)nextModule;
- (instancetype)previousModule;
- (instancetype)nextModuleOnSameDay;
- (instancetype)previousModuleOnSameDay;

+ (int)defaultMinutesOfAnticipation;

+ (RLMResults *)scheduleModulesOfDay:(ALMScheduleDay)day;
+ (RLMResults *)scheduleModulesOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm;


#pragma mark - Persistent information

@property NSString *initials;
@property int dayNumber;
@property int block;
@property int startHour;
@property int startMinute;
@property int endHour;
@property int endMinute;
@property int anticipationMinutes;


#pragma mark - Non-persistent information

@property (readonly, assign) ALMScheduleDay day;

@property (readonly) NSDate *startTime;
@property (readonly) NSDate *endTime;

- (NSDate *)startTimeWithAnticipation:(BOOL)anticipation;
- (NSDate *)endTimeWithAnticipation:(BOOL)anticipation;

// Always return the next (non-past) datetime
@property (readonly) NSDate *incomingStartTime;
@property (readonly) NSDate *incomingEndTime;

- (NSDate *)incomingStartTimeWithAnticipation:(BOOL)anticipation;
- (NSDate *)incomingEndTimeWithAnticipation:(BOOL)anticipation;


#pragma mark - Non-persistent information

+ (NSDate *)dateTimeForHour:(int)hour minutes:(int)minutes;


#pragma mark - Schedule Elements

+ (NSArray *)days;

+ (int)firstBlockOfDay:(ALMScheduleDay)day;
+ (int)firstBlockOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm;

+ (int)lastBlockOfDay:(ALMScheduleDay)day;
+ (int)lastBlockOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm;

+ (NSArray *)blocksOnDay:(ALMScheduleDay)day;
+ (NSArray *)blocksOnDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm;

+ (NSArray *)startTimesOnDay:(ALMScheduleDay)day;
+ (NSArray *)startTimesOnDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm;

+ (NSArray *)endTimesOnDay:(ALMScheduleDay)day;
+ (NSArray *)endTimesOnDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm;


@end
RLM_ARRAY_TYPE(ALMScheduleModule)
