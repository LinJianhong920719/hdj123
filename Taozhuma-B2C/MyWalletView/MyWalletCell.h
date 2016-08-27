//
//  MyWalletCell.h
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payTitle;
@property (weak, nonatomic) IBOutlet UILabel *payDate;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@end
