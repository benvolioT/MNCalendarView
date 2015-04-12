//
//  MNCalendarViewLayout.m
//  MNCalendarView
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNCalendarViewLayout.h"
#import "MNCalendarViewLayoutAttributes.h"

CGFloat const MNMonthHeaderViewHeight = 46.0f; // This is the height of a date cell on an iPhone 5. Might want to make this not a constant.

@implementation MNCalendarViewLayout

+ (Class) layoutAttributesClass {
    return [MNCalendarViewLayoutAttributes class];
}

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

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *layoutAttributesToReturn = [[NSMutableArray alloc] initWithCapacity:[layoutAttributes count]];
    
    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            UICollectionViewLayoutAttributes *newAttributes = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
            [layoutAttributesToReturn addObject:newAttributes];
        }
        else {
            [layoutAttributesToReturn addObject:attributes];
        }
    }
    
    return layoutAttributesToReturn;
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    MNCalendarViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];

    if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
        BOOL isFirstDayOfWeek = (indexPath.item == 0);
        
        [layoutAttributes setFirstDayOfWeek:isFirstDayOfWeek];
    }
    
    return layoutAttributes;
}

- (CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal:
            return [self targetContentOffsetForProposedContentOffsetHorizontal:proposedContentOffset withScrollingVelocity:velocity];
            break;
        case UICollectionViewScrollDirectionVertical:
            return [self targetContentOffsetForProposedContentOffsetVertical:proposedContentOffset withScrollingVelocity:velocity];
            break;
    }
}

- (CGPoint) targetContentOffsetForProposedContentOffsetHorizontal:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalOffset = proposedContentOffset.x;
    
    CGRect targetRect;
    if (ABS(velocity.x) < MINIMUM_VELOCITY_TO_SEEM_LIKE_THEY_MEAN_IT) {
        targetRect = CGRectMake(proposedContentOffset.x - self.collectionView.bounds.size.width, 0, (self.collectionView.bounds.size.width * 2.0f), self.collectionView.bounds.size.height);
    }
    else if (velocity.x > 0) {
        // scrolling right, so we want to look from halfway on, which will permit smooth scrolling to the next week
        targetRect = CGRectMake(proposedContentOffset.x + (self.collectionView.bounds.size.width / 2.0f), 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    else {
        // scrolling left, so we want to look from halfway back of the previous week, which will permit smooth scrolling to the previous week
        targetRect = CGRectMake(proposedContentOffset.x - self.collectionView.bounds.size.width, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    
    for (MNCalendarViewLayoutAttributes *layoutAttributes in array) {
        if (layoutAttributes.isFirstDayOfWeek) {
            CGFloat itemOffset = layoutAttributes.frame.origin.x;
            if (ABS(itemOffset - horizontalOffset) < ABS(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset;
            }
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (CGPoint) targetContentOffsetForProposedContentOffsetVertical:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {    
    CGRect targetRect;
    if (ABS(velocity.y) < MINIMUM_VELOCITY_TO_SEEM_LIKE_THEY_MEAN_IT) {
        targetRect = CGRectMake(0, proposedContentOffset.y - self.collectionView.bounds.size.height, self.collectionView.bounds.size.width, (self.collectionView.bounds.size.height * 2.0f));
    }
    else if (velocity.y > 0) {
        // scrolling down, so we want to look from halfway on, which will permit smooth scrolling to the next month
        targetRect = CGRectMake(0, proposedContentOffset.y + (self.collectionView.bounds.size.height / 2.0f), self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    else {
        // scrolling up, so we want to look from halfway back of the previous month, which will permit smooth scrolling to the previous month
        targetRect = CGRectMake(0, proposedContentOffset.y - self.collectionView.bounds.size.height, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    
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