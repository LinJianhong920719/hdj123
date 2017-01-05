//
//  ParentClassScrollViewController.h
//  Kitchen
//
//  Created by su on 16/7/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import "BaseViewController.h"

#define GoTop       @"goTop"
#define LeaveTop    @"leaveTop"

@interface ParentClassScrollViewController : BaseViewController

@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL canScroll;

@end
