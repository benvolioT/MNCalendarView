//
//  MNCalendarView.h
//  MNCalendarView
//
//  Created by Min Kim on 7/23/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNCalendarHeaderView.h"

#define MN_MINUTE                           60.f
#define MN_HOUR                             MN_MINUTE * 60.f
#define MN_DAY                              MN_HOUR * 24.f
#define MN_WEEK                             MN_DAY * 7.f
#define MN_YEAR                             MN_DAY * 365.f
#define MN_MAX_ROWS_TO_DISPLAY_A_MONTH      6
#define MN_NUMBER_OF_DAYS_VISIBLE_MONTH     MN_MAX_ROWS_TO_DISPLAY_A_MONTH * 7

typedef enum {
    MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH = 0,
    MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK = 1,
    MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL = 2
} MNCalendarViewLayoutMode;

@protocol MNCalendarViewDelegate;

@interface MNCalendarView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong,readonly) MNCalendarHeaderView *calendarHeaderView;
@property(nonatomic,strong,readonly) UICollectionView *datesCollectionView;
@property(nonatomic,assign) id<MNCalendarViewDelegate> delegate;
@property(nonatomic) MNCalendarViewLayoutMode layoutMode;

@property(nonatomic,strong) NSCalendar *calendar;
@property(nonatomic,copy)   NSDate     *fromDate;
@property(nonatomic,copy)   NSDate     *toDate;
@property(nonatomic,copy)   NSDate     *selectedDate;

@property(nonatomic,strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR; // default is the standard separator gray
@property(nonatomic,strong) UIColor *enabledTextColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *disabledTextColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *captionTextColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *enabledBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *disabledBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *highlightedTextColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *selectedColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *headerBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *headerTextColor UI_APPEARANCE_SELECTOR;

@property(nonatomic,strong) Class headerViewClass;
@property(nonatomic,strong) Class dayCellClass;

- (void)reloadData;
- (void)registerUICollectionViewClasses; 

@end

@protocol MNCalendarViewDelegate <NSObject>

@optional

- (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
- (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date;

@end
