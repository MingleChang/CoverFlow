//
//  MCCoverFlowItem.m
//  CoverFlow
//
//  Created by mingle on 2017/6/5.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import "MCCoverFlowItem.h"

@interface MCCoverFlowItem ()

@property (nonatomic, strong)UILabel *label;

@end

@implementation MCCoverFlowItem

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}
#pragma mark - Configure
- (void)configure {
    [self configureView];
    [self configureData];
}

- (void)configureView {
    self.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0];
    
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:30];
    self.label.textColor = [UIColor blackColor];
    [self addSubview:self.label];
}

- (void)configureData {
    
}
- (void)setIndex:(NSInteger)index {
    self.label.text = @(index).stringValue;
}
@end
