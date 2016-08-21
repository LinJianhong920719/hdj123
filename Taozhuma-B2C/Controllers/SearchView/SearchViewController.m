//
//  SearchViewController.m
//  搜索
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//


#import "SearchViewController.h"

@interface SearchViewController ()  {
    NSArray *_data;
    UIView *topView;

}


@end

@implementation SearchViewController



//- (void)loadView {
//    [super loadView];
//    self.title = @"我的";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMine:) name:@"refreshMine"object:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //隐藏导航栏
    [self hideNaviBar:YES];
    //初始化UI视图
    [self initTopNav];
    //自定义数据
//    [self customData];

}
//初始化头部导航栏
-(void)initTopNav{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    topView.backgroundColor = BACK_DEFAULT;
    //搜索view
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(10, 28, ScreenWidth*0.83, 29)];
    searchView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.1];
    //设置圆角
    searchView.layer.cornerRadius = 5;
    searchView.layer.masksToBounds = YES;
    
    //搜索图标
    UIImageView *_serachImage = [[UIImageView alloc]init];
    [_serachImage setFrame:CGRectMake(10, 10, 10, 10)];
    [_serachImage setImage:[UIImage imageNamed:@"icon_search"]];
    [searchView addSubview:_serachImage];
    //搜索field
    UITextField *searchLabel = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(_serachImage)+10, 0, searchView.frame.size.width-_serachImage.frame.size.width-15, 29)];
    searchLabel.font = [UIFont systemFontOfSize:12];
    searchLabel.placeholder = @"请输入搜索信息";
//    searchLabel.layer.cornerRadius =3.0;
//    searchLabel.borderStyle = UITextBorderStyleRoundedRect;
    searchLabel.backgroundColor = [UIColor clearColor];
    [searchView addSubview:searchLabel];
    //取消按钮
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(searchLabel)+10, 37, 24, 11)];
    [backBut setTitle:@"取消" forState:UIControlStateNormal];
    backBut.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    backBut.backgroundColor = [UIColor clearColor];
    //设置圆角

    [backBut setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    //将按钮添加到topView中
    [topView addSubview:backBut];
    //将视图添加到topView中
    [topView addSubview:searchView];
    
    [self.view addSubview:topView];
    //将一个UIView显示在最前面只需要调用其父视图的 bringSubviewToFront（）方法
    [self.view bringSubviewToFront:topView];
}


- (IBAction)backClick:(id)sender {

    // 返回上页
   
   [self.navigationController popToRootViewControllerAnimated:YES];
 
    
    
}

@end
