//
//  OrderListViewController.m
//  ScrollViewVC
//
//  Created by TreeWriteMac on 16/6/21.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import "OrderListViewController.h"
#import "NewCouponsViewController.h"
#import "UseCouponsViewController.h"
#import "OverdueCouponsViewController.h"
#import "CustomViewController.h"
#import "AllOrdersListViewController.h"
#import "NewOrdersListViewController.h"
#import "WaitOrdersListViewController.h"
#import "EvaluationOrdersListViewController.h"


//获取控制器的宽高
#define MeH self.view.frame.size.height
#define MeW self.view.frame.size.width

@interface OrderListViewController ()


@end

@implementation OrderListViewController

- (void)initWithAddVCARY:(NSArray *)VCS TitleS:(NSArray *)TitleS{
   
    _VCAry                        = VCS;
    _TitleAry                     = TitleS;
     NSLog(@"_TitleAry:%@",_TitleAry);
    self.edgesForExtendedLayout   = UIRectEdgeNone;

        //先初始化各个界面
    UIView *BJView                = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MeW, 40)];
    BJView.backgroundColor        = [UIColor whiteColor];
        [self.view addSubview:BJView];

    for (int i                    = 0 ; i<_VCAry.count; i++) {
    UIButton *btn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame                     = CGRectMake(i*(MeW/_VCAry.count), 0, MeW/_VCAry.count, BJView.frame.size.height-2);
            [btn setTitle:_TitleAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:255/255.0f green:80/255.0f blue:0 alpha:1.0] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    btn.tag                       = 1000+i;
            [btn addTarget:self action:@selector(SeleScrollBtn:) forControlEvents:UIControlEventTouchUpInside];
            [BJView addSubview:btn];
        }

    _LineView                     = [[UIView alloc] initWithFrame:CGRectMake(0, BJView.frame.size.height-2, MeW/_VCAry.count, 2)];
    _LineView.backgroundColor     = [UIColor redColor];
        [BJView addSubview:_LineView];
    
//    [self.view addSubview:BJView];
    _MeScroolView                 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BJView.frame.size.height+24+40, MeW, MeH-BJView.frame.size.height-64)];
    
    _MeScroolView.backgroundColor = [UIColor whiteColor];
    _MeScroolView.pagingEnabled   = YES;
    _MeScroolView.delegate        = self;
        [self.view addSubview:_MeScroolView];

    for (int i2                   = 0; i2<_VCAry.count; i2++) {
    UIView *view                  = [[_VCAry objectAtIndex:i2] view];
    view.frame                    = CGRectMake(i2*MeW, BJView.frame.size.height-40, MeW, _MeScroolView.frame.size.height);
            [_MeScroolView addSubview:view];
            [self addChildViewController:[_VCAry objectAtIndex:i2]];
        }

        [_MeScroolView setContentSize:CGSizeMake(MeW*_VCAry.count, _MeScroolView.frame.size.height)];
NSLog(@"y;%f",_MeScroolView.frame.origin.y);
}

/**
 *  滚动停止调用
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSLog(@"当前第几页====%d",index);
    
    /**
     *  此方法用于改变x轴
     */
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _LineView.frame;
        f.origin.x = index*(MeW/_VCAry.count);
        _LineView.frame = f;
    }];
    
    UIButton *btn = [self.view viewWithTag:1000+index];
    for (UIButton *b in btn.superview.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = (b==btn)?YES:NO;
        }
    }
    
}

//点击每个按钮然后选中对应的scroolview页面及选中按钮
-(void)SeleScrollBtn:(UIButton*)btn{
    for (UIButton *button in btn.superview.subviews)
    {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = (button != btn) ? NO : YES;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _LineView.frame;
        f.origin.x = (btn.tag-1000)*(MeW/_VCAry.count);
        _LineView.frame = f;
        _MeScroolView.contentOffset = CGPointMake((btn.tag-1000)*MeW, 0);
    }];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"我的订单"];

    [self initWithAddVCARY:@[[AllOrdersListViewController new],[NewOrdersListViewController new],[WaitOrdersListViewController new],[EvaluationOrdersListViewController new]]TitleS:@[@"全部",@"待付款",@"待收货",@"待评价"]];
    
//    [self initWithAddVCARY]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
