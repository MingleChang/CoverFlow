//
//  ViewController.m
//  CoverFlow
//
//  Created by 常峻玮 on 17/5/30.
//  Copyright © 2017年 Mingle. All rights reserved.
//

#import "ViewController.h"
#import "MCCoverFlowView.h"
#import "MCCoverFlow.h"

@interface ViewController ()<MCCoverFlowViewDelegate, MCCoverFlowDelegate>

@property (nonatomic, strong)MCCoverFlowView *flowView;

@property (nonatomic, strong)MCCoverFlow *flow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.flowView = [[MCCoverFlowView alloc] initWithImages:@[[UIImage imageNamed:@"0"],[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]]];
    self.flowView.backgroundColor = [UIColor redColor];
    self.flowView.delegate = self;
    [self.view addSubview:self.flowView];
    
    self.flow = [[MCCoverFlow alloc] initWithImages:@[[UIImage imageNamed:@"0"],[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]]];
    self.flow.backgroundColor = [UIColor orangeColor];
    self.flow.delegate = self;
    [self.view addSubview:self.flow];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.flowView.frame = CGRectMake(0, 50, self.view.frame.size.width, 150);
    
    self.flow.frame = CGRectMake(0, 250, self.view.frame.size.width, 150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MCCoverFlowView Delegate
- (void)coverFlowView:(MCCoverFlowView *)view selectedIndex:(NSInteger)index {
    NSLog(@"Selected:%li",index);
}

- (void)coverFlowView:(MCCoverFlowView *)view changeCurrentIndex:(NSInteger)index {
    NSLog(@"Current:%li",index);
}

#pragma mark - MCCoverFlow Delegate
- (void)coverFlow:(MCCoverFlow *)view selectedIndex:(NSInteger)index {
    NSLog(@"Selected:%li",index);
}
- (void)coverFlow:(MCCoverFlow *)view changeCurrentIndex:(NSInteger)index {
    NSLog(@"Current:%li",index);
}
- (void)coverFlowWillBeginDragging:(MCCoverFlow *)view {
    
}
- (void)coverFlowDidEndDragging:(MCCoverFlow *)view willDecelerate:(BOOL)decelerate {
    
}

@end
