//
//  AboutViewController.m
//  Taozhuma-B2C
//
//  Created by edz on 17/3/9.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _APPVersoin.text = [NSString stringWithFormat:@"版本号：%@",app_Version];
    //公司名称
    _CompanyName.text = @"汕头市彩虹世纪传媒科技有限公司";
    _CompanyNameEn.text = @"Shantou Rainbow Century Media Technology Co.,Ltd";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
