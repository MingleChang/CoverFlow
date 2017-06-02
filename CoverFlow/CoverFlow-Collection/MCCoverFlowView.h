//
//  MCCoverFlowView.h
//  CoverFlow
//
//  Created by 常峻玮 on 17/5/30.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCoverFlowView;

@protocol MCCoverFlowViewDelegate <NSObject>

- (void)coverFlowView:(MCCoverFlowView *)view selectedIndex:(NSInteger)index;
- (void)coverFlowView:(MCCoverFlowView *)view changeCurrentIndex:(NSInteger)index;



@end

@interface MCCoverFlowView : UIView

@property (nonatomic, weak)id<MCCoverFlowViewDelegate> delegate;

- (instancetype) initWithImages:(NSArray *)images;

@end
