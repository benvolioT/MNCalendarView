//
//  MNCalendarViewCell.h
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

CG_EXTERN void MNContextDrawLine(CGContextRef c, CGPoint start, CGPoint end, CGColorRef color, CGFloat lineWidth);

@interface MNCalendarViewCell : UICollectionViewCell

@property(nonatomic,strong) NSCalendar *calendar;

@property(nonatomic,assign,getter = isEnabled) BOOL enabled;

@property(nonatomic,strong) UIColor *separatorColor;
@property(nonatomic,strong) UIColor *enabledTextColor;
@property(nonatomic,strong) UIColor *disabledTextColor;
@property(nonatomic,strong) UIColor *enabledBackgroundColor;
@property(nonatomic,strong) UIColor *disabledBackgroundColor;
@property(nonatomic,strong) UIColor *highlightedTextColor;
@property(nonatomic,strong) UIColor *selectedColor;

@property(nonatomic,strong,readonly) UILabel *titleLabel;

@end
