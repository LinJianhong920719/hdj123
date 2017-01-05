//
//  MYSegmentView.m
//  Kitchen
//
//  Created by su on 16/8/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import "MYSegmentView.h"

#define btnTag 1000

@interface MYSegmentView ()

@property (nonatomic, assign) float segmentHeight;
@property (nonatomic, assign) float avgWidth;
@property (nonatomic, assign) CGSize lineSize;

@end

@implementation MYSegmentView

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentHeight, self.frame.size.width, self.frame.size.height - _segmentHeight)];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * self.controllers.count, 0);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UIView *)segmentView {
    
    if (!_segmentView) {
        
        _segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, _segmentHeight)];
        _segmentView.tag = 50;
        [self addSubview:_segmentView];
        
        UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _segmentHeight, self.frame.size.width, .5)];
        downLine.backgroundColor = [UIColor colorWithRed:220/255. green:220/255. blue:220/255. alpha:1.];
        [_segmentView addSubview:downLine];
    }
    
    return _segmentView;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc]initWithFrame:CGRectMake((_avgWidth - _lineSize.width)/2, _segmentHeight - _lineSize.height, _lineSize.width, _lineSize.height)];
        _line.backgroundColor = ColorFromHex(0xF8B725);
        _line.tag = 100;
    }
    return _line;
}

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray viewController:(UIViewController *)vc lineSize:(CGSize)lineSize segmentHeight:(float)height {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.segmentHeight = height;
        self.avgWidth = (frame.size.width/controllers.count);
        self.lineSize = lineSize;
        
        self.controllers = controllers;
        self.nameArray = titleArray;
        
        for (int i = 0; i < self.controllers.count; i++) {
            UIViewController *contr = self.controllers[i];
            [self.scrollView addSubview:contr.view];
            
            contr.view.frame = CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height);
            [vc addChildViewController:contr];
            [contr didMoveToParentViewController:vc];
        }
        
        for (int i = 0; i < self.controllers.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*(frame.size.width/self.controllers.count), 0, frame.size.width/self.controllers.count, height);
            btn.tag = i + btnTag;
            [btn setTitle:self.nameArray[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:ColorFromHex(0x898989) forState:(UIControlStateNormal)];
            [btn setTitleColor:ColorFromHex(0xF8B725) forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(Click:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.];

            [self.segmentView addSubview:btn];
            
            if (i == 0) {
                self.seleBtn = btn;
                self.seleBtn.selected = YES;
            }
        }
        
        if (titleArray.count > 1) {
            [self.segmentView addSubview:self.line];
        }
    }
    return self;
}

- (void)Click:(UIButton*)sender {
    
    self.seleBtn.selected = NO;
    self.seleBtn = sender;
    self.seleBtn.selected = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.line.centerX = self.frame.size.width/(self.controllers.count*2) + (self.frame.size.width/self.controllers.count)* (sender.tag - btnTag);
    }];
    
    [self.scrollView setContentOffset:CGPointMake((sender.tag - btnTag) * self.frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.line.centerX = self.frame.size.width/(self.controllers.count*2) +(self.frame.size.width/self.controllers.count)*(self.scrollView.contentOffset.x/self.frame.size.width);
    }];
    
    UIButton *btn = (UIButton*)[self.segmentView viewWithTag:(self.scrollView.contentOffset.x/self.frame.size.width) + btnTag];
    self.seleBtn.selected = NO;
    self.seleBtn = btn;
    self.seleBtn.selected = YES;
}

@end
