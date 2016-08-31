//
//  OrderSubmitView.m
//  MailWorldClient
//
//  Created by yusaiyan on 15/11/3.
//  Copyright © 2015年 QunYu_TD. All rights reserved.
//

#import "ConfirmSubmitView.h"
#import "AppConfig.h"

#define viewIndentation     20      //视图两边缩进

@implementation ConfirmSubmitView {
    UILabel *subtotalPrice;
    UILabel *freightLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self drawRectView:self.frame];
        
    }
    
    return self;
}

/**
 *  绘制初始视图
 */
- (void)drawRectView:(CGRect)rect {
    
    _total = 0;
    _freight = 0;
    _coupons = 0;
    _isRemote = NO;
    
    UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    topLine.backgroundColor = LINECOLOR_SYSTEM;
    [self addSubview:topLine];
    
    CGSize buttonSize = CGSizeMake(95, 42);
    
    _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-buttonSize.width, 0, buttonSize.width, 52)];
//    _submitButton.layer.cornerRadius = 4;
    [_submitButton setBackgroundColor:THEME_COLORS_RED];
    [_submitButton setTitle:@"支付订单" forState:UIControlStateNormal];
    [_submitButton.titleLabel setFont:[UIFont fontWithName:FontName_Default_Bold size:17]];
    [self addSubview:_submitButton];
    
    CGSize labelSize = CGSizeMake(ViewX(_submitButton)-10, 20);
    
    subtotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, labelSize.width, labelSize.height)];
    subtotalPrice.textColor = THEME_COLORS_RED;
    subtotalPrice.font = [UIFont fontWithName:FontName_Default_Bold size:14];
    subtotalPrice.textAlignment = NSTextAlignmentRight;
    [self addSubview:subtotalPrice];
    
    freightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(subtotalPrice), labelSize.width, labelSize.height)];
    freightLabel.textColor = COLOR_3E3A39;
    freightLabel.font = [UIFont fontWithName:FontName_Default_Bold size:13];
    freightLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:freightLabel];
    
}

- (void)reloadDisplayData {
    
    if (_isRemote) {
        subtotalPrice.text = [NSString stringWithFormat:@"总计:￥%0.1f",_total+_freight-_coupons];
        freightLabel.text = [NSString stringWithFormat:@"(含运费%0.1f)",_freight];
    } else {
        subtotalPrice.text = [NSString stringWithFormat:@"总计:￥%0.1f",_total-_coupons];
        freightLabel.text = [NSString stringWithFormat:@"(含运费%0.1f)",0.0];
    }
}

@end
