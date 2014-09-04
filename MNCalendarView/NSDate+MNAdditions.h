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

- (BOOL) mn_isFirstDateOfMonthInCalendar:(NSCalendar *)calendar;

- (BOOL) mn_isTodayInCalendar:(NSCalendar *)calendar;

- (BOOL) mn_isEarlierThanDate: (NSDate *) aDate;

- (BOOL) mn_isLaterThanDate: (NSDate *) aDate;

- (instancetype) mn_dateByAddingDays:(NSInteger)dDays calendar:(NSCalendar *)calendar;

- (instancetype) mn_dateAtBeginningOfDateInCalendar:(NSCalendar *)calendar;

@end
