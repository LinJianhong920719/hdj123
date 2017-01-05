//
//  MainGoodsViewCell.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 17/1/4.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "MainGoodsViewCell.h"

@implementation MainGoodsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(HotProductEntity *)model {
    
    if ([Tools isBlankString:model.goodImage]) {
        self.banner.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.banner sd_setImageWithURL:[NSURL URLWithString:model.goodImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.goodName]) {
        self.titleLabel.text = @"敬请期待";
    } else {
        self.titleLabel.text = model.goodName;
    }
    
    if ([Tools isBlankString:model.goodPrice]) {
        self.priceLabel.text = @"￥0.00";
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.goodPrice];
    }
    
}

@end
