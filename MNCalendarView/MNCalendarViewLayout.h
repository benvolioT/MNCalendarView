//
//  MNCalendarViewLayout.h
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNCalendarView.h"

extern CGFloat const MNMonthHeaderViewHeight;

@interface MNCalendarViewLayout : UICollectionViewFlowLayout

- (id)initWithLayoutMode:(MNCalendarViewLayoutMode)layoutMode;

@end
