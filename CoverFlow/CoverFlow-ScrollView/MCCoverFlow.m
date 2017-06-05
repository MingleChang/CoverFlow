//
//  MCCoverFlow.m
//  CoverFlow
//
//  Created by mingle on 2017/6/2.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import "MCCoverFlow.h"
#import "MCCoverFlowItem.h"

#define Show_Count 3

@interface MCCoverFlow () <UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, copy)NSArray<MCCoverFlowItem *> *items;

@property (nonatomic, assign)NSInteger duplicate;
@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, assign)NSInteger sourceCount;

@end

@implementation MCCoverFlow

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGFloat width = [self itemWidth];
    CGFloat height = self.scrollView.bounds.size.height;
    NSInteger itemCount = [self itemCount];
    [self.scrollView setContentSize:CGSizeMake(itemCount * width, height)];
    [self.scrollView setContentOffset:CGPointMake((self.currentIndex + self.sourceCount) * width, 0) animated:NO];
    for (NSInteger i = 0; i < self.items.count; i ++) {
        MCCoverFlowItem *item = [self.items objectAtIndex:i];
        item.frame = CGRectMake(i * width, 0, width, height);
    }
    [self coverFlowItemByOffset:CGPointMake((self.currentIndex + self.sourceCount) * width, 0)];
}

#pragma mark - Private
- (CGFloat)itemWidth {
    return self.bounds.size.width / Show_Count;
}

- (NSInteger)itemCount {
    return self.sourceCount * self.duplicate;
}

- (void)addSubItems {
    NSMutableArray *lItems = [NSMutableArray array];
    CGFloat width = [self itemWidth];
    CGFloat height = self.scrollView.bounds.size.height;
    NSInteger itemCount = [self itemCount];
    for (NSInteger i = 0; i < itemCount; i ++) {
        MCCoverFlowItem *lItem = [[MCCoverFlowItem alloc] init];
        lItem.tag = i;
        lItem.index = i % self.sourceCount;
        [lItem setIndex:i];
        lItem.frame = CGRectMake(i * width, 0, width, height);
        [lItems addObject:lItem];
        [self.scrollView addSubview:lItem];
    }
    self.items = lItems;
}

- (void)didScrollViewContentOffsetChange {
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat width = [self itemWidth];
    CGFloat offsetIndex = contentOffset.x / width;
    NSInteger index = floor(offsetIndex + 0.5);
    
    if (index < self.sourceCount - 2 ) {
        [self.scrollView setContentOffset:CGPointMake(contentOffset.x + self.sourceCount * width, 0) animated:NO];
    }
    if (index + 2 > self.sourceCount * 2 + 1 ) {
        [self.scrollView setContentOffset:CGPointMake(contentOffset.x - self.sourceCount * width, 0) animated:NO];
    }
}

- (void)endScrollViewDraggingAndDecelerate {
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat width = [self itemWidth];
    NSInteger index = floor(contentOffset.x / width + 0.5);
    contentOffset.x = width * index;
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

- (void)coverFlowItemByOffset:(CGPoint)contentOffset {
    for (MCCoverFlowItem *item in self.items) {
        CGFloat lCenterX = self.scrollView.bounds.size.width / 2.0;
        CGFloat lOffsetCenterX = contentOffset.x + lCenterX;
        CGFloat offset = lOffsetCenterX - item.center.x;
        CGFloat ratio = offset / lCenterX;
        CATransform3D lTransform = CATransform3DIdentity;
        lTransform.m34 = -0.003;
        if (ratio > 1) {
            ratio = 1;
        }
        if (ratio < -1) {
            ratio = -1;
        }
        lTransform = CATransform3DRotate(lTransform, M_PI_2 * ratio, 0, 1, 0);
        item.layer.transform = lTransform;
    }
}

- (void)calculateCurrentIndexByOffset:(CGPoint)contentOffset {
    CGFloat width = [self itemWidth];
    CGFloat offsetIndex = contentOffset.x / width;
    NSInteger index = floor(offsetIndex + 0.5);
    if (fabs(offsetIndex - index) < 0.1 && self.pageIndex != index) {
        self.pageIndex = index;
        NSLog(@"PageIndex:%li",self.pageIndex);
        if (self.pageIndex % self.sourceCount != self.currentIndex) {
            self.currentIndex = self.pageIndex % self.sourceCount;
            NSLog(@"CurrentIndex:%li",self.currentIndex);
        }
    }
}

#pragma mark - KVO 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.scrollView] && [keyPath isEqualToString:@"contentOffset"]) {
        CGPoint lNewOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint lOldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        if (CGPointEqualToPoint(lNewOffset, lOldOffset)) {
            return;
        }
        [self coverFlowItemByOffset:lNewOffset];
        [self calculateCurrentIndexByOffset:lNewOffset];
    }
}

#pragma mark - Delegate
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView.isDragging || self.scrollView.isDecelerating) {
        [self didScrollViewContentOffsetChange];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self endScrollViewDraggingAndDecelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    [self endScrollViewDraggingAndDecelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark - Configure
- (void)configure {
    [self configureView];
    [self configureData];
}

- (void)configureView {
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
}

- (void)configureData {
    self.duplicate = 3;
    self.sourceCount = 3;
    self.pageIndex = self.sourceCount;
    self.currentIndex = self.pageIndex % self.sourceCount;
    
    [self addSubItems];
}

@end
