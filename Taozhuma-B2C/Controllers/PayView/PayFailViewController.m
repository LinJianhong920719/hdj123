//
//  PayFailViewController.m
//  Taozhuma-B2C
//
//  Created by edz on 17/1/3.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "PayFailViewController.h"
#import "OrderListViewController.h"

@interface PayFailViewController ()

@end

@implementation PayFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//重新支付
- (IBAction)payAgain:(id)sender {
    OrderListViewController *allOrderView = [[OrderListViewController alloc]init];
    allOrderView.title = @"我的订单";
    allOrderView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allOrderView animated:YES];
}
@end
