//
//  EffectiveCouponsCell.h
//  Taozhuma-B2C
//
//  Created by Average on 16/8/24.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EffectiveCouponsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *couponsName;
@property (weak, nonatomic) IBOutlet UILabel *couponsGoods;
@property (weak, nonatomic) IBOutlet UILabel *couponsDate;
@property (weak, nonatomic) IBOutlet UIImageView *couponsImage;

@end
