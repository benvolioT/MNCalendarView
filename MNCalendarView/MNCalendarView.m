//
//  MNCalendarView.m
//  MNCalendarView
//
//  Created by Min Kim on 7/23/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarView.h"
#import "MNCalendarViewLayout.h"
#import "MNCalendarViewDayCell.h"
#import "MNMonthHeaderView.h"
#import "MNFastDateEnumeration.h"
#import "NSDate+MNAdditions.h"

@interface MNCalendarView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong,readwrite) MNCalendarHeaderView *calendarHeaderView;
@property(nonatomic,strong,readwrite) UICollectionView *datesCollectionView;
@property(nonatomic,strong,readwrite) MNCalendarViewLayout *datesCollectionViewLayout;
@property(nonatomic,strong,readwrite) NSArray *datesCollectionViewLayoutConstraints;
@property(nonatomic,strong,readwrite) NSArray *calendarHeaderViewLayoutConstraints;

@property(nonatomic,strong,readwrite) NSArray *sectionDates;
@property(nonatomic,assign,readwrite) NSUInteger daysInWeek;

@property(nonatomic,strong,readwrite) NSDateFormatter *monthFormatter;
@property(nonatomic,strong,readwrite) NSDateFormatter *shortMonthFormatter;
@property(nonatomic,strong,readwrite) NSArray *weekdaySymbols;

- (NSDate *)firstVisibleDateOfSection:(NSDate *)date;
- (NSDate *)lastVisibleDateOfSection:(NSDate *)date;

- (BOOL)dateEnabled:(NSDate *)date;
- (BOOL)canSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)applyConstraints;

@end

@implementation MNCalendarView

- (void) commonInit {
    self.calendar   = NSCalendar.currentCalendar;
    self.fromDate   = [NSDate.date mn_beginningOfDay:self.calendar];
    self.toDate     = [self.fromDate dateByAddingTimeInterval:MN_YEAR * 4];
    self.daysInWeek = 7;

    _layoutMode = MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH;
    
    self.headerViewClass  = MNMonthHeaderView.class;
    self.dayCellClass     = MNCalendarViewDayCell.class;
    
    _separatorColor = [UIColor colorWithRed:.85f green:.85f blue:.85f alpha:1.f];
    _headerBackgroundColor = [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
    _headerTextColor = [UIColor darkTextColor];
    
    [self addSubview:self.calendarHeaderView];
    [self addSubview:self.datesCollectionView];
    [self applyConstraints];
    [self reloadData];
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if ( self ) {
        [self commonInit];
    }
    
    return self;
}

- (MNCalendarHeaderView *) calendarHeaderView {
    if (nil == _calendarHeaderView) {
        _calendarHeaderView = [[MNCalendarHeaderView alloc] initWithFrame:CGRectZero];
        
        _calendarHeaderView.backgroundColor = self.headerBackgroundColor;
        _calendarHeaderView.daysInWeek = self.daysInWeek;
        _calendarHeaderView.textColor = self.headerTextColor;
        _calendarHeaderView.separatorColor = self.separatorColor;
        _calendarHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
        _calendarHeaderView.userInteractionEnabled = FALSE;
        _calendarHeaderView.layer.zPosition = 1024;
    }
    return _calendarHeaderView;
}

- (UICollectionView *) datesCollectionView {
    if (nil == _datesCollectionView) {
        _datesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                  collectionViewLayout:self.datesCollectionViewLayout];
        _datesCollectionView.backgroundColor = self.headerBackgroundColor;
        _datesCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _datesCollectionView.showsHorizontalScrollIndicator = NO;
        _datesCollectionView.showsVerticalScrollIndicator = NO;
        _datesCollectionView.dataSource = self;
        _datesCollectionView.delegate = self;
        _datesCollectionView.layer.zPosition = 1023;
        
        [self registerDatesCollectionViewClasses];
    }
    return _datesCollectionView;
}

- (MNCalendarViewLayout *) datesCollectionViewLayout {
    if (nil == _datesCollectionViewLayout) {
        _datesCollectionViewLayout = [[MNCalendarViewLayout alloc] initWithLayoutMode:self.layoutMode];
    }
    return _datesCollectionViewLayout;
}

- (void) setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    _calendarHeaderView.separatorColor = separatorColor;
}

- (void) setHeaderBackgroundColor:(UIColor *)headerBackgroundColor {
    _headerBackgroundColor = headerBackgroundColor;
    _calendarHeaderView.backgroundColor = headerBackgroundColor;
}

- (void) setHeaderTextColor:(UIColor *)headerTextColor {
    _headerTextColor = headerTextColor;
    _calendarHeaderView.textColor = headerTextColor;
}

- (void) setCalendar:(NSCalendar *)calendar {
    _calendar = calendar;
    
    self.monthFormatter = [[NSDateFormatter alloc] init];
    self.monthFormatter.calendar = calendar;
    [self.monthFormatter setDateFormat:@"MMMM yyyy"];
    
    self.shortMonthFormatter = [[NSDateFormatter alloc] init];
    self.shortMonthFormatter.calendar = calendar;
    [self.shortMonthFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.shortMonthFormatter setDateFormat:@"MMM"];
    
    self.weekdaySymbols = self.monthFormatter.shortWeekdaySymbols;

}

- (void) setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = [selectedDate mn_beginningOfDay:self.calendar];
}

- (void) setLayoutMode:(MNCalendarViewLayoutMode)layoutMode {
    _layoutMode = layoutMode;
    [self applyConstraints];
    
    [self reloadData];
    
    [self.datesCollectionViewLayout setLayoutMode:layoutMode];
    
    [self.datesCollectionView setCollectionViewLayout:self.datesCollectionViewLayout
                                             animated:TRUE
                                           completion:^(BOOL finished) {
                                               // Nothing for now.
                                           }];
}

- (void) reloadData {
    [self reloadSectionDates];    
    [self.datesCollectionView reloadData];
}

- (void) reloadSectionDates {
    NSMutableArray *sectionDates = @[].mutableCopy;
    
    NSCalendarUnit calendarUnit;
    switch (self.layoutMode) {
        case MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH:
            calendarUnit = NSMonthCalendarUnit;
            break;
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK:
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL:
            calendarUnit = NSWeekCalendarUnit;
            break;
    }
    
    MNFastDateEnumeration *enumeration =
    [[MNFastDateEnumeration alloc] initWithFromDate:[self.fromDate mn_firstDateOfMonth:self.calendar]
                                             toDate:[self.toDate mn_firstDateOfMonth:self.calendar]
                                           calendar:self.calendar
                                               unit:calendarUnit];
    for (NSDate *date in enumeration) {
        [sectionDates addObject:date];
    }
    
    self.sectionDates = sectionDates;
}

- (void) registerDatesCollectionViewClasses {
    [_datesCollectionView registerClass:self.dayCellClass
             forCellWithReuseIdentifier:MNCalendarViewDayCellIdentifier];
    
    [_datesCollectionView registerClass:self.headerViewClass
             forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                    withReuseIdentifier:MNMonthHeaderViewIdentifier];
}

- (NSDate *) firstVisibleDateOfSection:(NSDate *)date {
    switch (self.layoutMode) {
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK:
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL:
        {
            return [date mn_firstDateOfWeek:self.calendar];
            break;
        }
        case MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH:
        {
            date = [date mn_firstDateOfMonth:self.calendar];
            
            NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                                                            fromDate:date];
            
            return [[date mn_dateWithDay:-((components.weekday - 1) % self.daysInWeek) calendar:self.calendar] dateByAddingTimeInterval:MN_DAY];

            break;
        }
    }
}

- (NSDate *) lastVisibleDateOfSection:(NSDate *)date {
    switch (self.layoutMode) {
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK:
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL:
        {
            date = [date mn_firstDateOfWeek:self.calendar];
            
            NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                                                            fromDate:date];
            
            return [date mn_dateWithDay:components.day + (self.daysInWeek - 1)
                               calendar:self.calendar];

            break;
        }
        case MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH:
        {
            NSDate *firstDate = [self firstVisibleDateOfSection:[date dateAtBeginningOfDateInCalendar:self.calendar]];
            NSDate *lastDate = [firstDate dateByAddingDays:(MN_NUMBER_OF_DAYS_VISIBLE_MONTH - 1) calendar:self.calendar];            
            return lastDate;
        }
    }
}

- (void) applyConstraints {
    NSDictionary *views = @{@"datesCollectionView" : self.datesCollectionView,
                            @"calendarHeaderView" : self.calendarHeaderView};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[datesCollectionView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[calendarHeaderView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];


    if (self.datesCollectionViewLayoutConstraints) {
        [self removeConstraints:self.datesCollectionViewLayoutConstraints];
    }
    switch (self.layoutMode) {
        case MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH:
        {
            self.datesCollectionViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[datesCollectionView]|"
                                                                                                options:0
                                                                                                metrics:nil
                                                                                                  views:views];
            break;
        }
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK:
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL:
        {
            self.datesCollectionViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[calendarHeaderView][datesCollectionView]|"
                                                                                                options:0
                                                                                                metrics:nil
                                                                                                  views:views];
            break;
        }
    }
    [self addConstraints:self.datesCollectionViewLayoutConstraints];

    if (self.calendarHeaderViewLayoutConstraints) {
        [self removeConstraints:self.calendarHeaderViewLayoutConstraints];
    }
    CGFloat calendarHeaderHeight = (self.layoutMode == MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL) ? 0 : MNMonthHeaderViewHeight;
    self.calendarHeaderViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:
                                                [NSString stringWithFormat:@"V:|[calendarHeaderView(%f)]", calendarHeaderHeight]
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:views];
    
    [self addConstraints:self.calendarHeaderViewLayoutConstraints];
}

- (BOOL) dateEnabled:(NSDate *)date {
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
        return [self.delegate calendarView:self shouldSelectDate:date];
    }
    return YES;
}

- (BOOL) canSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MNCalendarViewCell *cell = (MNCalendarViewCell *)[self collectionView:self.datesCollectionView cellForItemAtIndexPath:indexPath];
    
    BOOL enabled = cell.enabled;
    
    if ([cell isKindOfClass:MNCalendarViewDayCell.class] && enabled) {
        MNCalendarViewDayCell *dayCell = (MNCalendarViewDayCell *)cell;
        
        enabled = [self dateEnabled:dayCell.date];
    }
    
    return enabled;
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGFloat width = size.width;
    
    CGSize sizeOfCell = [self collectionView:self.datesCollectionView
                                      layout:self.datesCollectionViewLayout
                      sizeForItemAtIndexPath:[NSIndexPath
                                              indexPathForRow:0
                                              inSection:0]];
    CGFloat heightOfRow = sizeOfCell.height;
    CGFloat height = (self.layoutMode == MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH) ? (MN_MAX_ROWS_TO_DISPLAY_A_MONTH * heightOfRow) : heightOfRow;
    
    if (self.layoutMode != MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL) {
        height += MNMonthHeaderViewHeight;
    }
    
    return CGSizeMake(width, height);
}


#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionDates.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.layoutMode) {
        case MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH:
        {
            NSDate *sectionDate = self.sectionDates[section];
            NSDate *firstVisibleDateOfSection = [self firstVisibleDateOfSection:sectionDate];
            NSDate *lastVisibleDateOfSection = [self lastVisibleDateOfSection:sectionDate];
            
            NSDateComponents *components =
            [self.calendar components:NSDayCalendarUnit
                             fromDate:firstVisibleDateOfSection
                               toDate:lastVisibleDateOfSection
                              options:0];
            
            NSUInteger numberOfDaysInSection = components.day + 1; // add 1 because the above calculation is exclusive of the toDate parameter
            return numberOfDaysInSection;

            break;
        }
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK:
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL:
            return self.daysInWeek;
            break;
    }
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView
            viewForSupplementaryElementOfKind:(NSString *)kind
                                  atIndexPath:(NSIndexPath *)indexPath {
    
    MNMonthHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                       withReuseIdentifier:MNMonthHeaderViewIdentifier
                                                                              forIndexPath:indexPath];
    
    headerView.backgroundColor = self.headerBackgroundColor;
    headerView.titleLabel.textColor = self.headerTextColor;
    headerView.titleLabel.text = [self.monthFormatter stringFromDate:self.sectionDates[indexPath.section]];
    
    return headerView;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MNCalendarViewDayCell *cell = [_datesCollectionView dequeueReusableCellWithReuseIdentifier:MNCalendarViewDayCellIdentifier
                                                                                  forIndexPath:indexPath];
    
    [self styleCell:cell];
    
    NSDate *date = [self setDateOnCell:cell forIndexPath:indexPath];
    
    if (cell.enabled) {
        [cell setEnabled:[self dateEnabled:date]];
    }
    
    if (cell.enabled && [date isFirstDateOfMonthInCalendar:self.calendar]) {
        NSString *monthLabel = [self.shortMonthFormatter stringFromDate:date];
        cell.monthLabel.text = monthLabel;
    }
    else {
        cell.monthLabel.text = nil;
    }
    
    if (self.layoutMode == MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL) {
        NSString *dayOfWeekLabel = self.weekdaySymbols[indexPath.item];
        cell.dayOfWeekLabel.text = dayOfWeekLabel;
    }
    else {
        cell.dayOfWeekLabel.text = nil;
    }
    
    if (self.selectedDate && cell.enabled) {
        [cell setSelected:[date isEqualToDate:self.selectedDate]];
    }
    
    return cell;
}

- (void) styleCell:(MNCalendarViewDayCell *)cell {
    cell.separatorColor = self.separatorColor;
    cell.selectedColor = self.selectedColor;
    cell.enabledTextColor = self.enabledTextColor;
    cell.disabledTextColor = self.disabledTextColor;
    cell.highlightedTextColor = self.highlightedTextColor;
    cell.enabledBackgroundColor = self.enabledBackgroundColor;
    cell.disabledBackgroundColor = self.disabledBackgroundColor;
    cell.monthTextColor = self.captionTextColor;
    cell.dayOfWeekTextColor = self.captionTextColor;
}

- (NSDate *) setDateOnCell:(MNCalendarViewDayCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    NSDate *sectionDate = self.sectionDates[indexPath.section];
    NSDate *firstDateInSection = [self firstVisibleDateOfSection:sectionDate];
    
    NSUInteger day = indexPath.item;
    NSDateComponents *components = [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                    fromDate:firstDateInSection];
    components.day += day;
    NSDate *date = [self.calendar dateFromComponents:components];
    
    switch (self.layoutMode) {
        case MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH:
            [cell setDate:date
                    month:sectionDate
                 calendar:self.calendar];
            break;
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK:
        case MN_CALENDAR_VIEW_LAYOUT_MODE_WEEK_MINIMAL:
            [cell setDate:date
                 calendar:self.calendar];
            break;
    }
    
    return date;
}

#pragma mark - UICollectionViewDelegate

- (BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self canSelectItemAtIndexPath:indexPath];
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self canSelectItemAtIndexPath:indexPath];
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MNCalendarViewCell *cell = (MNCalendarViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:MNCalendarViewDayCell.class] && cell.enabled) {
        MNCalendarViewDayCell *dayCell = (MNCalendarViewDayCell *)cell;
        
        self.selectedDate = dayCell.date;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView:self didSelectDate:dayCell.date];
        }
        
        [self.datesCollectionView reloadData];
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    CGFloat width      = self.bounds.size.width;
    CGFloat itemWidth  = roundf(width / self.daysInWeek);
    CGFloat itemHeight = itemWidth;
    
    NSUInteger weekday = indexPath.item % self.daysInWeek;
    
    if (weekday == self.daysInWeek - 1) {
        itemWidth = width - (itemWidth * (self.daysInWeek - 1));
    }
    
    return CGSizeMake(itemWidth, itemHeight);
}

@end