//
//  MCCoverFlow.h
//  CoverFlow
//
//  Created by mingle on 2017/6/2.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCoverFlow;
@protocol MCCoverFlowDelegate <NSObject>

- (void)coverFlow:(MCCoverFlow *)view selectedIndex:(NSInteger)index;
- (void)coverFlow:(MCCoverFlow *)view changeCurrentIndex:(NSInteger)index;

@end

@interface MCCoverFlow : UIView

@property (nonatomic, weak)id<MCCoverFlowDelegate> delegate;

@end
