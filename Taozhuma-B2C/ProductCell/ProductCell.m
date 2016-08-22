//
//  ProductCell.m
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

@synthesize productImage;
@synthesize productName;
@synthesize productPrice;
@synthesize addCart;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
