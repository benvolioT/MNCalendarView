//
//  MNCalendarHeaderView.h
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNCalendarHeaderView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong,readonly) UICollectionView *daysOfWeekCollectionView;

@property(nonatomic,strong) NSCalendar *calendar;
@property(nonatomic,assign,readwrite) NSUInteger daysInWeek;

@property(nonatomic,strong) Class weekdayCellClass;

@property(nonatomic,strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR;

@end
