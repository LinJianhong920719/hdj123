//
//  PaySuccessViewController.m
//  Taozhuma-B2C
//
//  Created by edz on 17/1/3.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "OrderListViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backMainView:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refCart" object:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    OrderListViewController *allOrderView = [[OrderListViewController alloc]init];
    allOrderView.title = @"我的订单";
    allOrderView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allOrderView animated:YES];
}
@end
