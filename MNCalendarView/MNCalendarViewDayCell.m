//
//  MNCalendarViewDayCell.m
//  MNCalendarView
//
//  Created by Min Kim on 7/28/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewDayCell.h"

NSString *const MNCalendarViewDayCellIdentifier = @"MNCalendarViewDayCellIdentifier";

@interface MNCalendarViewDayCell()

@property(nonatomic,strong,readwrite) NSDate *date;
@property(nonatomic,assign,readwrite) NSUInteger weekday;

@end

@implementation MNCalendarViewDayCell

- (void) setDate:(NSDate *)date
           month:(NSDate *)month
        calendar:(NSCalendar *)calendar {
    
    self.date     = date;
    self.calendar = calendar;
    
    NSDateComponents *components =
    [self.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:self.date];
    
    NSDateComponents *monthComponents =
    [self.calendar components:NSMonthCalendarUnit
                     fromDate:month];
    
    self.weekday = components.weekday;
    self.titleLabel.text = [NSString stringWithFormat:@"%d", components.day];
    self.enabled = monthComponents.month == components.month;
    
    [self setNeedsDisplay];
}

- (void) setDate:(NSDate *)date
        calendar:(NSCalendar *)calendar {
    
    self.date     = date;
    self.calendar = calendar;
    
    NSDateComponents *components =
    [self.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:self.date];
    
    self.weekday = components.weekday;
    self.titleLabel.text = [NSString stringWithFormat:@"%d", components.day];
    self.enabled = TRUE;
    
    [self setNeedsDisplay];
}

- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    self.titleLabel.textColor = ((self.enabled) ? self.enabledTextColor : self.disabledTextColor);
    
    self.backgroundColor =
    self.enabled ? self.enabledBackgroundColor : self.disabledBackgroundColor;
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.titleLabel.textColor = self.selectedTextColor;
    }
    else {
        self.titleLabel.textColor = ((self.enabled) ? self.enabledTextColor : self.disabledTextColor);
    }
}

- (void) setToday:(BOOL)isToday {
    _today = isToday;
    
    if (isToday) {
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.f]];

        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
        self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text
                                                                         attributes:underlineAttribute];
        
    }
    else {
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    }
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef separatorColor = self.separatorColor.CGColor;
    
    CGSize size = self.bounds.size;
    
    CGFloat pixel = 1.f / [UIScreen mainScreen].scale;
    MNContextDrawLine(context,
                      CGPointMake(size.width - pixel, pixel),
                      CGPointMake(size.width - pixel, size.height),
                      separatorColor,
                      pixel);
}

@end
