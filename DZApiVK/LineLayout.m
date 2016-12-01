//
//  LineLayout.m
//  DZApiVK
//
//  Created by Dima Tixon on 01/12/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "LineLayout.h"

#define ITEM_SIZE 200.0

@implementation LineLayout

#define ACTIVE_DISTANCE 46 //200
#define ZOOM_FACTOR 0.3

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(46, 46);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 5, 0, 0);
        self.minimumLineSpacing = 2.f;
    
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizeDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizeDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = round(zoom);
            }
        }
    }
    
    return array;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {

    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizonyalCenter = proposedContentOffset.x +
    (CGRectGetWidth(self.collectionView.bounds)) / 2.0;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0,
                                   self.collectionView.bounds.size.width,
                                   self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizonyalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizonyalCenter;
        }
    }

    return CGPointMake(proposedContentOffset.x + offsetAdjustment,
                       proposedContentOffset.y);
}

































@end
