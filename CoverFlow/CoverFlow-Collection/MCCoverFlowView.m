//
//  MCCoverFlowView.m
//  CoverFlow
//
//  Created by 常峻玮 on 17/5/30.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import "MCCoverFlowView.h"
#import "MCCoverFlowCell.h"
#import "MCCoverFlowLayout.h"

#define Show_Count 3
static NSString *const CELL_ID = @"MCCoverFlowCell";

@interface MCCoverFlowView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, copy)NSArray *imageArray;

@property (nonatomic, assign)NSInteger duplicate;
@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, assign)NSInteger sourceCount;

@property (nonatomic, assign, readonly)CGFloat cellWidth;

@end

@implementation MCCoverFlowView

- (instancetype) initWithImages:(NSArray *)images {
    self = [super init];
    if (self) {
        self.imageArray = images;
        [self configure];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    CGFloat width = self.cellWidth;
    [self.collectionView setContentOffset:CGPointMake((self.pageIndex - 1) * width, 0) animated:NO];
}

#pragma mark - Private
- (void)resetCollectionPageOffset {
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat width = self.cellWidth;
    NSInteger index = floor(contentOffset.x / width + 0.5);
    contentOffset.x = width * index;
    [self.collectionView setContentOffset:contentOffset animated:YES];
}

- (void)resetCollectionViewIndexPath {
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat width = self.cellWidth;
    CGFloat offsetIndex = contentOffset.x / width;
    NSInteger index = floor(offsetIndex + 0.5);
    
    if (index < self.sourceCount ) {
        index = index + self.sourceCount;
        [self.collectionView setContentOffset:CGPointMake(index * width, 0) animated:NO];
    }
    if (index + 2 > self.sourceCount * 2 ) {
        index = index - self.sourceCount;
        [self.collectionView setContentOffset:CGPointMake(index * width, 0) animated:NO];
    }
}

- (void)collectionViewContentOffsetChange {
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat width = self.cellWidth;
    CGFloat offsetIndex = contentOffset.x / width;
    NSInteger index = floor(offsetIndex + 0.5);
    
    [self resetCurrentIndexWithOffsetIndex:offsetIndex andIndex:index];
    
    if (index < self.sourceCount - 2 ) {
        [self.collectionView setContentOffset:CGPointMake(contentOffset.x + self.sourceCount * width, 0) animated:NO];
    }
    if (index + 2 > self.sourceCount * 2 + 1 ) {
        [self.collectionView setContentOffset:CGPointMake(contentOffset.x - self.sourceCount * width, 0) animated:NO];
    }
}

- (void)resetCurrentIndexWithOffsetIndex:(CGFloat)offsetIndex andIndex:(NSInteger)index {
    if (fabs(offsetIndex - index) < 0.1 && self.pageIndex != index + 1) {
        self.pageIndex = index + 1;
        if (self.pageIndex % self.sourceCount != self.currentIndex) {
            self.currentIndex = self.pageIndex % self.sourceCount;
            if ([self.delegate respondsToSelector:@selector(coverFlowView:changeCurrentIndex:)]) {
                [self.delegate coverFlowView:self changeCurrentIndex:self.currentIndex];
            }
//            NSLog(@"%li == %li", self.pageIndex , self.currentIndex);
        }
    }
}

#pragma mark - Setter And Getter
- (CGFloat)cellWidth {
    return self.collectionView.frame.size.width / Show_Count;
}

#pragma mark - Delegate
#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sourceCount * self.duplicate;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MCCoverFlowCell *lCell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    UIImage *lImage = [self.imageArray objectAtIndex:indexPath.item % self.sourceCount];
    [lCell setupImage:lImage];
    [lCell setIndex:indexPath.item];
    return lCell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"WillDisplayCell:%li",indexPath.item);
//    NSLog(@"%@",cell);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = [indexPath item];
    CGFloat width = [self cellWidth];
    [self.collectionView setContentOffset:CGPointMake(width * (item - 1), 0) animated:YES];
    if ([self.delegate respondsToSelector:@selector(coverFlowView:selectedIndex:)]) {
        [self.delegate coverFlowView:self selectedIndex:item % self.sourceCount];
    }
//    NSLog(@"Selected Index: %li",item % self.sourceCount);
}

#pragma mark - UICollectionView Delegate FlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self cellWidth];
    CGFloat height = width * 80 / 125.0;
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //修改willDisplayCell不能及时执行的问题，不建议如此修改
//    [self.collectionView reloadData];
    
    if (scrollView.isDragging || scrollView.isDecelerating) {
        [self collectionViewContentOffsetChange];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self resetCollectionPageOffset];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    [self resetCollectionPageOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self resetCollectionPageOffset];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self resetCollectionViewIndexPath];
}

#pragma mark - Configure
- (void)configure {
    [self configureView];
    [self configureData];
}

- (void)configureView {
    MCCoverFlowLayout *lLayout = [[MCCoverFlowLayout alloc] init];
    lLayout.estimatedItemSize = CGSizeMake(self.frame.size.width/3.0, self.frame.size.width / 3.0 * 80 / 125.0);
    lLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lLayout];
    self.collectionView.bounces = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[MCCoverFlowCell class] forCellWithReuseIdentifier:CELL_ID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
}

- (void)configureData {
    self.duplicate = 3;
    self.sourceCount = self.imageArray.count;
    self.pageIndex = self.sourceCount;
    self.currentIndex = self.pageIndex % self.sourceCount;
    
    
}

@end
