//
//  ALMScheduleModule.m
//  AlmappCore
//
//  Created by Patricio López on 18-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMScheduleModule.h"
#import "ALMResourceConstants.h"

@implementation NSArray (ScheduleModule)

- (int)maxNumber {
    int xmax = INT32_MIN;
    for (NSNumber *num in self) {
        int x = num.intValue;
        if (x > xmax) xmax = x;
    }
    return xmax;
}

- (int)minNumber {
    int xmin = INT32_MAX;
    for (NSNumber *num in self) {
        int x = num.intValue;
        if (x < xmin) xmin = x;
    }
    return xmin;
}

@end

@implementation ALMScheduleModule

+ (NSDictionary *)JSONInboundMappingDictionary {
    id a = @{
             [self jatt:kAResourceID]       : kRResourceID,
             [self jatt:kAInitials]         : kRInitials,
             [self jatt:kADay]              : kRDay,
             [self jatt:kABlock]            : kRBlock,
             [self jatt:kAStartTimeHour]    : kRStartTimeHour,
             [self jatt:kAStartTimeMinute]  : kRStartTimeMinute,
             [self jatt:kAEndTimeHour]      : kREndTimeHour,
             [self jatt:kAEndTimeMinute]    : kREndTimeMinute,
             };
    return a;
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             kRInitials                     : kRDefaultNullString,
             @"anticipationMinutes"         : @([self defaultMinutesOfAnticipation]),
             kRDay                          : @0,
             kRBlock                        : @0,
             kRStartTimeHour                : @0,
             kRStartTimeMinute              : @0,
             kREndTimeHour                  : @0,
             kREndTimeMinute                : @0
             };
}

+ (NSString *)apiSingleForm {
    return @"schedule_module";
}

+ (NSString *)realmSingleForm {
    return @"scheduleModule";
}

+ (ALMScheduleDay)dayAfter:(ALMScheduleDay)day {
    if (day == ALMScheduleDaySunday) {
        return ALMScheduleDayMonday;
    }
    else {
        return day + 1;
    }
}

+ (ALMScheduleDay)dayBefore:(ALMScheduleDay)day {
    if (day == ALMScheduleDayMonday) {
        return ALMScheduleDaySunday;
    }
    else {
        return day - 1;
    }
}


#pragma mark - Schedule Modules

+ (instancetype)moduleForDay:(int)day block:(int)block {
    return [self moduleForDay:day block:block inRealm:[RLMRealm defaultRealm]];
}

+ (instancetype)moduleForDay:(int)day block:(int)block inRealm:(RLMRealm *)realm {
    NSString *query = [NSString stringWithFormat:@"%@ = %d AND %@ = %d",kRDay, (int)day, kRBlock, block ];
    return [ALMScheduleModule objectsInRealm:realm where:query].firstObject;
}

+ (instancetype)nextModuleOf:(ALMScheduleModule*)module {
    if (module.block == [self lastBlockOfDay:module.day inRealm:module.realm]) {
        ALMScheduleModule *nextModule;
        ALMScheduleDay nextDay = module.day;
        while (nextModule == nil) {
            nextDay = [self dayAfter:nextDay];
            nextModule = [self firstModuleOfDay:nextDay inRealm:module.realm];
        }
        return nextModule;
    }
    else {
        ALMScheduleModule *nextModule;
        int nextBlock = module.block;
        while (nextModule == nil) {
            nextBlock++;
            nextModule = [self moduleForDay:module.day block:nextBlock inRealm:module.realm];
        }
        return nextModule;
    }
}

+ (instancetype)previousModuleOf:(ALMScheduleModule*)module {
    if (module.block == [self firstBlockOfDay:module.day inRealm:module.realm]) {
        ALMScheduleModule *pastModule;
        ALMScheduleDay pastDay = module.day;
        while (pastModule == nil) {
            pastDay = [self dayBefore:pastDay];
            pastModule = [self lastModuleOfDay:pastDay inRealm:module.realm];
        }
        return pastModule;
    }
    else {
        ALMScheduleModule *pastModule;
        int pastBlock = module.block;
        while (pastModule == nil) {
            pastBlock--;
            pastModule = [self moduleForDay:module.day block:pastBlock inRealm:module.realm];
        }
        return pastModule;
    }
}

+ (instancetype)firstModuleOfDay:(ALMScheduleDay)day {
    return [self firstModuleOfDay:day inRealm:[RLMRealm defaultRealm]];
}

+ (instancetype)firstModuleOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm {
    int firstBlock = [self firstBlockOfDay:day inRealm:realm];
    return [self moduleForDay:day block:firstBlock inRealm:realm];
}

+ (instancetype)lastModuleOfDay:(ALMScheduleDay)day {
    return [self lastModuleOfDay:day inRealm:[RLMRealm defaultRealm]];
}

+ (instancetype)lastModuleOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm {
    int lastBlock = [self lastBlockOfDay:day inRealm:realm];
    return [self moduleForDay:day block:lastBlock inRealm:realm];
}

- (instancetype)nextModule {
    return [ALMScheduleModule nextModuleOf:self];
}

- (instancetype)previousModule {
    return [ALMScheduleModule previousModuleOf:self];
}

- (instancetype)nextModuleOnSameDay {
    ALMScheduleModule *next = [self nextModule];
    return (next.day == self.day) ? next : nil;
}

- (instancetype)previousModuleOnSameDay {
    ALMScheduleModule *previous = [self previousModule];
    return (previous.day == self.day) ? previous : nil;
}

+ (int)defaultMinutesOfAnticipation {
    return 5;
}

+ (RLMResults *)scheduleModulesOfDay:(ALMScheduleDay)day {
    return [self scheduleModulesOfDay:day inRealm:[RLMRealm defaultRealm]];
}

+ (RLMResults *)scheduleModulesOfDay:(ALMScheduleDay)day inRealm:(RLMRealm *)realm {
    return [[self objectsInRealm:realm where:[NSString stringWithFormat:@"%@ = %d", kRDay, (int)day]] sortedResultsUsingProperty:kRBlock ascending:YES];
}

#pragma mark - Non-persistent information

- (int)dayIniOS {
    if (self.day == ALMScheduleDaySunday) {
        return 1;
    }
    else {
        return self.dayNumber + 1;
    }
}

- (ALMScheduleDay)day {
    return self.dayNumber;
}

- (NSDate *)startTime {
    return [self startTimeWithAnticipation:NO];
}

- (NSDate *)endTime {
    return [self endTimeWithAnticipation:NO];
}

- (NSDate *)startTimeWithAnticipation:(BOOL)anticipation {
    NSInteger anticipationValue = (anticipation) ? self.anticipationMinutes : 0;
    return [self.class dateTimeForDay:self.day hour:self.startHour minutes:self.startMinute anticipation:anticipationValue];
}

- (NSDate *)endTimeWithAnticipation:(BOOL)anticipation {
    NSInteger anticipationValue = (anticipation) ? self.anticipationMinutes : 0;
    return [self.class dateTimeForDay:self.day hour:self.endHour minutes:self.endMinute anticipation:anticipationValue];
}

- (NSDate *)incomingStartTimeWithAnticipation:(BOOL)anticipation{
    NSDate *incoming = [self startTimeWithAnticipation:anticipation];
    NSDate *now = [NSDate date];
    
    if ([now compare:incoming] == NSOrderedDescending) {
        return [incoming dateByAddingTimeInterval:60*60*24*7];
    }
    else {
        return incoming;
    }
}

- (NSDate *)incomingEndTimeWithAnticipation:(BOOL)anticipation {
    NSDate *incoming = [self endTimeWithAnticipation:anticipation];
    NSDate *now = [NSDate date];
    
    if ([now compare:incoming] == NSOrderedDescending) {
        return [incoming dateByAddingTimeInterval:60*60*24*7];
    }
    else {
        return incoming;
    }
}

- (NSDate *)incomingStartTime {
    return [self incomingStartTimeWithAnticipation:NO];
}

- (NSDate *)incomingEndTime {
    return [self incomingEndTimeWithAnticipation:NO];
}


#pragma mark - Schedule elements

+ (NSArray *)days {
    NSMutableArray *days = [NSMutableArray arrayWithCapacity:7];
    for (int day = ALMScheduleDayMonday; day <= ALMScheduleDaySunday; day++) {
        [days addObject:[NSNumber numberWithInt:day]];
    }
    return days;
}

+ (int)firstBlockOfDay:(ALMScheduleDay)day {
    return [self firstBlockOfDay:day inRealm:[RLMRealm defaultRealm]];
}

+ (int)firstBlockOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm {
    NSArray *dayBlocks = [ALMScheduleModule blocksOnDay:day inRealm:realm];
    return [dayBlocks minNumber];
}

+ (int)lastBlockOfDay:(ALMScheduleDay)day {
    return [self lastBlockOfDay:day inRealm:[RLMRealm defaultRealm]];
}

+ (int)lastBlockOfDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm {
    NSArray *dayBlocks = [ALMScheduleModule blocksOnDay:day inRealm:realm];
    return [dayBlocks maxNumber];
}

+ (NSArray *)blocksOnDay:(ALMScheduleDay)day {
    return [self blocksOnDay:day inRealm:[RLMRealm defaultRealm]];
}

+ (NSArray *)startTimesOnDay:(ALMScheduleDay)day {
    return [self startTimesOnDay:day inRealm:[RLMRealm defaultRealm]];
}

+ (NSArray *)endTimesOnDay:(ALMScheduleDay)day {
    return [self endTimesOnDay:day inRealm:[RLMRealm defaultRealm]];
}

+ (RLMResults*)allModulesInDay:(ALMScheduleDay)day inRealm:(RLMRealm*)realm {
    NSString *query = [NSString stringWithFormat:@"%@ = %d", kRDay, (int)day];
    return [[self objectsInRealm:realm where:query] sortedResultsUsingProperty:kRResourceID ascending:YES] ;
}

+ (NSArray *)blocksOnDay:(ALMScheduleDay)day inRealm:(RLMRealm *)realm {
    NSMutableArray *array = [NSMutableArray array];
    for (ALMScheduleModule *module in [self allModulesInDay:day inRealm:realm]) {
        [array addObject:[NSNumber numberWithInt:module.block]];
    }
    return array;
}

+ (NSArray *)startTimesOnDay:(ALMScheduleDay)day inRealm:(RLMRealm *)realm {
    NSMutableArray *array = [NSMutableArray array];
    for (ALMScheduleModule *module in [self allModulesInDay:day inRealm:realm]) {
        [array addObject:module.startTime];
    }
    return array;
}

+ (NSArray *)endTimesOnDay:(ALMScheduleDay)day inRealm:(RLMRealm *)realm {
    NSMutableArray *array = [NSMutableArray array];
    for (ALMScheduleModule *module in [self allModulesInDay:day inRealm:realm]) {
        [array addObject:module.endTime];
    }
    return array;
}


#pragma mark - Non-persistent information

+ (NSDate *)dateTimeForDay:(ALMScheduleDay)day hour:(int)hour minutes:(int)minutes anticipation:(NSInteger)anticipation{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    
    NSDateComponents* comps = [gregorian components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    [comps setWeekday:2]; // 2: monday
    NSDate *firstDayOfTheWeek = [gregorian dateFromComponents:comps];
    NSInteger seconds = minutes*60 + hour*60*60 + 60*60*24*(day-1) - anticipation*60;
    
    return [firstDayOfTheWeek dateByAddingTimeInterval:seconds];
}

+ (NSDate *)dateTimeForHour:(int)hour minutes:(int)minutes {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSUInteger timeComps = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit);
    NSDateComponents *components = [gregorian components: timeComps fromDate: [NSDate date]];
    [components setHour: hour];
    [components setMinute: minutes];
    [components setSecond:0];
    
    return [gregorian dateFromComponents: components];
}

@end
