//
//  MNCalendarViewLayout.m
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewLayout.h"

CGFloat const MNMonthHeaderViewHeight = 46.0f; // This is the height of a date cell on an iPhone 5. Might want to make this not a constant.

@implementation MNCalendarViewLayout

- (id) initWithLayoutMode:(MNCalendarViewLayoutMode)layoutMode {
    if (self = [super init]) {
        [self setLayoutMode:layoutMode];
        
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumInteritemSpacing = 0.f;
        self.minimumLineSpacing = 0.f;
        self.footerReferenceSize = CGSizeZero;

    }
    
    return self;
}

- (void) setLayoutMode:(MNCalendarViewLayoutMode)layoutMode {
    BOOL isScrollVertically = (layoutMode == MN_CALENDAR_VIEW_LAYOUT_MODE_MONTH);
    
    self.scrollDirection = (isScrollVertically) ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
    self.headerReferenceSize = (self.scrollDirection == UICollectionViewScrollDirectionVertical) ? CGSizeMake(0.f, MNMonthHeaderViewHeight) : CGSizeMake(0.f, 0.f);

}

// TODO: make this page weeks like we page months.
- (CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    NSArray *array =
    [super layoutAttributesForElementsInRect:({
        CGRect bounds = self.collectionView.bounds;
        bounds.origin.y = proposedContentOffset.y - self.collectionView.bounds.size.height/2.f;
        bounds.size.width *= 1.5f;
        bounds;
    })];
    
    CGFloat minOffsetY = CGFLOAT_MAX;
    UICollectionViewLayoutAttributes *targetLayoutAttributes = nil;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            CGFloat offsetY = fabs(layoutAttributes.frame.origin.y - proposedContentOffset.y);
            
            if (offsetY < minOffsetY) {
                minOffsetY = offsetY;
                
                targetLayoutAttributes = layoutAttributes;
            }
        }
    }
    
    if (targetLayoutAttributes) {
        return targetLayoutAttributes.frame.origin;
    }
    
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
}

@end