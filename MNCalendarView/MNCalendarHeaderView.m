//
//  MNCalendarHeaderView.m
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarHeaderView.h"
#import "MNCalendarViewWeekdayCell.h"

@interface MNCalendarHeaderView()

@property(nonatomic,strong,readwrite) UICollectionView *daysOfWeekCollectionView;
@property(nonatomic,strong,readwrite) NSArray *weekdaySymbols;

@end

@implementation MNCalendarHeaderView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.weekdayCellClass = MNCalendarViewWeekdayCell.class;
        
        self.calendar = NSCalendar.currentCalendar;
        
        [self addSubview:self.daysOfWeekCollectionView];
        [self applyConstraints];
    }
    return self;
}

- (void) setCalendar:(NSCalendar *)calendar {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = self.calendar;
    self.weekdaySymbols = formatter.shortWeekdaySymbols;
    
    [self.daysOfWeekCollectionView reloadData];
}

- (UICollectionView *) daysOfWeekCollectionView {
    if (nil == _daysOfWeekCollectionView) {
        _daysOfWeekCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                       collectionViewLayout:self.daysOfWeekCollectionViewLayout];
        _daysOfWeekCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _daysOfWeekCollectionView.showsHorizontalScrollIndicator = NO;
        _daysOfWeekCollectionView.showsVerticalScrollIndicator = NO;
        _daysOfWeekCollectionView.dataSource = self;
        _daysOfWeekCollectionView.delegate = self;
        _daysOfWeekCollectionView.backgroundColor = [UIColor redColor];
        
        [self registerDaysOfWeekCollectionViewClasses];
    }
    return _daysOfWeekCollectionView;
}

- (UICollectionViewFlowLayout *) daysOfWeekCollectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    
    return layout;
}

- (void) registerDaysOfWeekCollectionViewClasses {
    [_daysOfWeekCollectionView registerClass:self.weekdayCellClass
                  forCellWithReuseIdentifier:MNCalendarViewWeekdayCellIdentifier];
}

- (void) applyConstraints {
    NSDictionary *views = @{@"daysOfWeekCollectionView" : self.daysOfWeekCollectionView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[daysOfWeekCollectionView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[daysOfWeekCollectionView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.daysInWeek;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MNCalendarViewWeekdayCell *cell =
    [_daysOfWeekCollectionView dequeueReusableCellWithReuseIdentifier:MNCalendarViewWeekdayCellIdentifier
                                                         forIndexPath:indexPath];
    
    cell.backgroundColor = self.backgroundColor;
    cell.titleLabel.text = self.weekdaySymbols[indexPath.item];
    cell.titleLabel.textColor = self.textColor;
    cell.separatorColor = self.separatorColor;        
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return FALSE;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return FALSE;
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

// TODO?
//- (CGSize) sizeThatFits:(CGSize)size {
//    CGSize sizeOfCell = [self collectionView:self.daysOfWeekCollectionView
//                                      layout:self.daysOfWeekCollectionViewLayout
//                      sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    
//    return CGSizeMake(self.bounds.size.width, sizeOfCell.height);
//}

@end
