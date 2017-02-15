//
//  WithdrawalViewController.h
//  Taozhuma-B2C
//  钱包提现
//  Created by edz on 17/2/13.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "BaseViewController.h"

@interface WithdrawalViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *zfbAccount;
@property (weak, nonatomic) IBOutlet UITextField *money;

- (IBAction)withdrawAction:(id)sender;
@end
