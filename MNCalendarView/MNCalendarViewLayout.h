//
//  MNCalendarViewLayout.h
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNCalendarView.h"

#define MINIMUM_VELOCITY_TO_SEEM_LIKE_THEY_MEAN_IT      0.2f

extern CGFloat const MNMonthHeaderViewHeight;

@interface MNCalendarViewLayout : UICollectionViewFlowLayout

- (id) initWithLayoutMode:(MNCalendarViewLayoutMode)layoutMode;

@property (nonatomic) MNCalendarViewLayoutMode layoutMode;

@end
