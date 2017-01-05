//
//  ParentClassScrollViewController.m
//  Kitchen
//
//  Created by su on 16/7/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import "ParentClassScrollViewController.h"

@interface ParentClassScrollViewController () <UIGestureRecognizerDelegate>

@end

@implementation ParentClassScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:GoTop object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:LeaveTop object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)acceptMsg:(NSNotification *)notification {
    
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:GoTop]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        }
    } else if([notificationName isEqualToString:LeaveTop]) {
        self.scrollView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LeaveTop object:nil userInfo:@{@"canScroll":@"1"}];
    }
    
    _scrollView = scrollView;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
