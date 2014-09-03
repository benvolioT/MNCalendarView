//
//  MNCalendarViewLayoutAttributes.h
//  Pods
//
//  Created by Ben Truitt on 9/2/14.
//
//

#import <UIKit/UIKit.h>

@interface MNCalendarViewLayoutAttributes : UICollectionViewLayoutAttributes <NSCopying>

@property (nonatomic, getter = isFirstDayOfWeek) BOOL firstDayOfWeek;

@end
