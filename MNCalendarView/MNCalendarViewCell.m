//
//  MNCalendarViewCell.m
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewCell.h"

void MNContextDrawLine(CGContextRef c, CGPoint start, CGPoint end, CGColorRef color, CGFloat lineWidth) {
    CGContextSetAllowsAntialiasing(c, false);
    CGContextSetStrokeColorWithColor(c, color);
    CGContextSetLineWidth(c, lineWidth);
    CGContextMoveToPoint(c, start.x, start.y - (lineWidth/2.f));
    CGContextAddLineToPoint(c, end.x, end.y - (lineWidth/2.f));
    CGContextStrokePath(c);
    CGContextSetAllowsAntialiasing(c, true);
}

NSString *const MNCalendarViewCellIdentifier = @"MNCalendarViewCellIdentifier";

@interface MNCalendarViewCell()

@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *monthLabel;
@property(nonatomic,strong,readwrite) UILabel *dayOfWeekLabel;

@end

@implementation MNCalendarViewCell

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = UIColor.clearColor;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self setupLabel:self.titleLabel];
        [self.contentView addSubview:self.titleLabel];
        
        CGRect monthRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 3.0f);
        self.monthLabel = [[UILabel alloc] initWithFrame:monthRect];
        [self setupLabel:self.monthLabel];
        self.monthLabel.font = [UIFont boldSystemFontOfSize:10.f];
        [self.contentView addSubview:self.monthLabel];
        
        CGRect dayOfWeekRect = CGRectMake(0, self.bounds.size.height * (2.0f / 3.0f), self.bounds.size.width, self.bounds.size.height / 3.0f);
        self.dayOfWeekLabel = [[UILabel alloc] initWithFrame:dayOfWeekRect];
        [self setupLabel:self.dayOfWeekLabel];
        self.dayOfWeekLabel.font = [UIFont systemFontOfSize:9.f];
        [self.contentView addSubview:self.dayOfWeekLabel];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.23f green:0.61f blue:1.f alpha:1.f];
    }
    return self;
}

- (void) setupLabel:(UILabel *)label {
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    label.font = [UIFont systemFontOfSize:14.f];
    label.highlightedTextColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = NO;
    label.backgroundColor = [UIColor clearColor];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.selectedBackgroundView.frame = self.bounds;
}

- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef separatorColor = self.separatorColor.CGColor;
    
    CGFloat pixel = 1.f / [UIScreen mainScreen].scale;
    MNContextDrawLine(context,
                      CGPointMake(0.f, self.bounds.size.height),
                      CGPointMake(self.bounds.size.width, self.bounds.size.height),
                      separatorColor,
                      pixel);
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.titleLabel.textColor = self.selectedTextColor;
        self.monthLabel.textColor = self.selectedTextColor;
        self.dayOfWeekLabel.textColor = self.selectedTextColor;
    }
    else {
        self.titleLabel.textColor = self.highlightedTextColor;
        self.monthLabel.textColor = self.monthTextColor;
        self.dayOfWeekLabel.textColor = self.dayOfWeekTextColor;
    }
}

- (void) setHighlightedTextColor:(UIColor *)textColor {
    _highlightedTextColor = textColor;
    
    self.titleLabel.highlightedTextColor = textColor;
    self.monthLabel.highlightedTextColor = textColor;
    self.dayOfWeekLabel.highlightedTextColor = textColor;
}

- (void) setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.selectedBackgroundView.backgroundColor = selectedColor;
}

- (void) setMonthTextColor:(UIColor *)monthTextColor {
    _monthTextColor = monthTextColor;
    self.monthLabel.textColor = monthTextColor;
}

- (void) setDayOfWeekTextColor:(UIColor *)dayOfWeekTextColor {
    _dayOfWeekTextColor = dayOfWeekTextColor;
    self.dayOfWeekLabel.textColor = dayOfWeekTextColor;
}

@end
