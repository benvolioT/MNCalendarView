//
//  MNCalendarViewDayCell.h
//  MNCalendarView
//
//  Created by Min Kim on 7/28/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewCell.h"

extern NSString *const MNCalendarViewDayCellIdentifier;

@interface MNCalendarViewDayCell : MNCalendarViewCell

@property(nonatomic,strong) UIColor *enabledTextColor;
@property(nonatomic,strong) UIColor *disabledTextColor;
@property(nonatomic,strong) UIColor *enabledBackgroundColor;
@property(nonatomic,strong) UIColor *disabledBackgroundColor;

@property(nonatomic,assign,getter = isToday) BOOL today;

@property(nonatomic,strong,readonly) NSDate *date;

- (void)setDate:(NSDate *)date
          month:(NSDate *)month
       calendar:(NSCalendar *)calendar;

- (void)setDate:(NSDate *)date
       calendar:(NSCalendar *)calendar;

@end
