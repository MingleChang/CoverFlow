//
//  MCCoverFlowCell.m
//  CoverFlow
//
//  Created by 常峻玮 on 17/5/30.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import "MCCoverFlowCell.h"

@interface MCCoverFlowCell ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *label;

@end

@implementation MCCoverFlowCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
    
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:30];
    self.label.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.label];
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
