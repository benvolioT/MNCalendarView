//
//  NSDate+MNAdditions.m
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "NSDate+MNAdditions.h"

@implementation NSDate (MNAdditions)

- (instancetype)mn_firstDateOfMonth:(NSCalendar *)calendar {
  if (nil == calendar) {
    calendar = [NSCalendar currentCalendar];
  }
  
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  
  [components setDay:1];
  
  return [calendar dateFromComponents:components];
}

- (instancetype)mn_lastDateOfMonth:(NSCalendar *)calendar {
  if (nil == calendar) {
    calendar = [NSCalendar currentCalendar];
  }
  
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  [components setDay:0];
  [components setMonth:components.month + 1];
  
  return [calendar dateFromComponents:components];
}

- (instancetype)mn_firstDateOfWeek:(NSCalendar *)calendar {
    if (nil == calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    /*
     Create a date components to represent the number of days to subtract
     from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so
     subtract 1 from the number
     of days to subtract from the date in question.  (If today's Sunday,
     subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    /* Substract [calendar firstWeekday] to handle first day of the week being something else than Sunday */
    [componentsToSubtract setDay: - ([weekdayComponents weekday] - [calendar firstWeekday])];
    NSDate *beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the
     original date (self).
     To normalize to midnight, extract the year, month, and day components
     and create a new date from those components.
     */
    NSDateComponents *components = [calendar components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate: beginningOfWeek];
    return [calendar dateFromComponents: components];
}

- (instancetype)mn_beginningOfDay:(NSCalendar *)calendar {
  if (nil == calendar) {
    calendar = [NSCalendar currentCalendar];
  }
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  [components setHour:0];
  
  return [calendar dateFromComponents:components];
}

- (instancetype)mn_dateWithDay:(NSUInteger)day calendar:(NSCalendar *)calendar {
  if (nil == calendar) {
    calendar = [NSCalendar currentCalendar];
  }
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  
  [components setDay:day];
  
  return [calendar dateFromComponents:components];
}

- (BOOL) mn_isFirstDateOfMonthInCalendar:(NSCalendar *)calendar {
    if (nil == calendar) {
        calendar = [NSCalendar currentCalendar];
    }
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    
    return (components.day == 1);
}

- (BOOL) mn_isEqualToDateIgnoringTime:(NSDate *)aDate calendar:(NSCalendar *)calendar {
	NSDateComponents *components1 = [calendar components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [calendar components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]) &&
			([components1 day] == [components2 day]));
}

- (BOOL) mn_isTodayInCalendar:(NSCalendar *)calendar {
	return [self mn_isEqualToDateIgnoringTime:[NSDate date] calendar:calendar];
}

- (BOOL) mn_isEarlierThanDate: (NSDate *) aDate {
	return ([self earlierDate:aDate] == self && ![self isEqualToDate:aDate]);
}

- (BOOL) mn_isLaterThanDate: (NSDate *) aDate {
	return ([self laterDate:aDate] == self && ![self isEqualToDate:aDate]);
}

- (instancetype) mn_dateByAddingDays:(NSInteger)dDays calendar:(NSCalendar *)calendar {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:dDays];
    return [calendar dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (instancetype) mn_dateAtBeginningOfDateInCalendar:(NSCalendar *)calendar {
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}

@end
