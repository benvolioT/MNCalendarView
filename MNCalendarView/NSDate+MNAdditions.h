//
//  NSDate+MNAdditions.h
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_DAY		86400
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)

@interface NSDate (MNAdditions)

- (instancetype)mn_firstDateOfMonth:(NSCalendar *)calendar;

- (instancetype)mn_lastDateOfMonth:(NSCalendar *)calendar;

- (instancetype)mn_firstDateOfWeek:(NSCalendar *)calendar;

- (instancetype)mn_beginningOfDay:(NSCalendar *)calendar;

- (instancetype)mn_dateWithDay:(NSUInteger)day calendar:(NSCalendar *)calendar;

- (BOOL) isFirstDateOfMonthInCalendar:(NSCalendar *)calendar;

- (BOOL) isTodayInCalendar:(NSCalendar *)calendar;

- (instancetype) dateByAddingDays:(NSInteger)dDays calendar:(NSCalendar *)calendar;

- (instancetype) dateAtBeginningOfDateInCalendar:(NSCalendar *)calendar;

@end
