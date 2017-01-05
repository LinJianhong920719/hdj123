//
//  MainGoodsViewCell.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 17/1/4.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotProductEntity.h"

#define CellIdentifier @"MainGoodsViewCell"

@interface MainGoodsViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *banner;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

- (void)setCellData:(HotProductEntity *)model;

@end
