//
//  MCCoverFlowItem.m
//  CoverFlow
//
//  Created by mingle on 2017/6/5.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import "MCCoverFlowItem.h"

@interface MCCoverFlowItem ()

@property (nonatomic, strong)UIImageView *imageView;
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
    self.imageView.frame = self.bounds;
    self.label.frame = self.bounds;
}
#pragma mark - Configure
- (void)configure {
    [self configureView];
    [self configureData];
}

- (void)configureView {
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:30];
    self.label.textColor = [UIColor blackColor];
    [self addSubview:self.label];
}

- (void)configureData {
    
}
- (void)setupImage:(UIImage *)image {
    self.imageView.image = image;
}
- (void)setIndex:(NSInteger)index {
    self.label.text = @(index).stringValue;
}
@end
