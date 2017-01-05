//
//  MYSegmentView.h
//  Kitchen
//
//  Created by su on 16/8/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSegmentView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *seleBtn;

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray viewController:(UIViewController *)vc lineSize:(CGSize)lineSize segmentHeight:(float)height;

@end
