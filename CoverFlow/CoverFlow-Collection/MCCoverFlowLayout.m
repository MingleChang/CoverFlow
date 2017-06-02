//
//  MCCoverFlowLayout.m
//  Flow
//
//  Created by mingle on 2017/2/27.
//  Copyright © 2017年 mingle. All rights reserved.
//

#import "MCCoverFlowLayout.h"

@implementation MCCoverFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    CGFloat lCenterX = self.collectionView.bounds.size.width * 0.5;
    
    CGFloat lOffsetCenterX = self.collectionView.contentOffset.x + lCenterX;
    
//    NSArray *lLayoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    NSArray *lLayoutAttributesArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    for (UICollectionViewLayoutAttributes *lLayoutAttributes in lLayoutAttributesArray) {
        
        CGFloat offset = lOffsetCenterX - lLayoutAttributes.center.x;
        CGFloat ratio = offset / lCenterX;
        CATransform3D lTransform = CATransform3DIdentity;
        lTransform.m34 = -0.003;
        if (ratio > 1) {
//            ratio = 1;
            ratio = 0;
            lLayoutAttributes.alpha = 0;
        }
        if (ratio < -1) {
//            ratio = -1;
            ratio = -0;
            lLayoutAttributes.alpha = 0;
        }
        lTransform = CATransform3DRotate(lTransform, M_PI_2 * ratio, 0, 1, 0);
        lLayoutAttributes.transform3D = lTransform;
        
    }
    
    return lLayoutAttributesArray;
    
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat lCenterX = self.collectionView.bounds.size.width * 0.5;
    CGFloat lOffsetCenterX = proposedContentOffset.x + lCenterX;
    
    CGFloat lVisibleX = proposedContentOffset.x;
    CGFloat lVisibleY = proposedContentOffset.y;
    CGFloat lVisibleWidth = self.collectionView.bounds.size.width;
    CGFloat lVisibleHeight = self.collectionView.bounds.size.height;
    
    CGRect lVisibleRect = CGRectMake(lVisibleX, lVisibleY, lVisibleWidth, lVisibleHeight);
    
    NSArray *lLayoutAttributesArray = [super layoutAttributesForElementsInRect:lVisibleRect];
    
    int lMiniIndex = 0;
    UICollectionViewLayoutAttributes *lMiniLayoutAttributes = lLayoutAttributesArray[lMiniIndex];
    
    for (int i = 1; i < lLayoutAttributesArray.count; i++) {
        
        UICollectionViewLayoutAttributes *lLayoutAttributes = lLayoutAttributesArray[i];
        
        if (ABS(lLayoutAttributes.center.x - lOffsetCenterX) < ABS(lMiniLayoutAttributes.center.x - lOffsetCenterX)) {
            lMiniIndex = i;
            lMiniLayoutAttributes = lLayoutAttributes;
        }
    }
    
    
    CGFloat lOffsetX = lMiniLayoutAttributes.center.x - lOffsetCenterX;
    
    
    return CGPointMake(proposedContentOffset.x + lOffsetX, proposedContentOffset.y);    
}

@end
