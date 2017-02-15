//
//  RechargeViewController.h
//  Taozhuma-B2C
//
//  Created by edz on 17/2/15.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RechargeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *zfbCheckBtn;//支付宝选择按钮
@property (weak, nonatomic) IBOutlet UIImageView *wxCheckBtn;//微信选择按钮
@property (weak, nonatomic) IBOutlet UITextField *money;//充值金额
@property (weak, nonatomic) NSString *payType;//支付类型

- (IBAction)zfbAction:(id)sender;//支付宝事件
- (IBAction)wxAction:(id)sender;//微信事件
- (IBAction)rechargeAction:(id)sender;//充值事件
@end
