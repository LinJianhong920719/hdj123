//
//  ConfirmSectionFooterView.m
//  MailWorldClient
//
//  Created by yusaiyan on 15/11/4.
//  Copyright © 2015年 QunYu_TD. All rights reserved.
//

#import "ConfirmSectionFooterView.h"
#import "AppConfig.h"

#define ViewIndentation     20      //视图两边缩进
#define titleHeight         30      //标题部分高度

@implementation ConfirmSectionFooterView {
    UILabel *priceLabel;
    UILabel *numberLabel;
    UILabel *preferentialLabel;
    UIImageView *iconRMB;
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
    
    CGFloat labelHeight = 35;
    
    UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(ViewIndentation, 0, ScreenWidth-ViewIndentation*2, 0.5)];
    topLine.backgroundColor = LINECOLOR_SYSTEM;
    [self addSubview:topLine];
    
    priceLabel = [[UILabel alloc]init];
    [priceLabel setTextColor:THEME_COLORS_RED];
    [priceLabel setFont:[UIFont fontWithName:FontName_Default size:14]];
    [self addSubview:priceLabel];

    preferentialLabel = [[UILabel alloc]init];
    [preferentialLabel setTextColor:COLOR_898989];
    [preferentialLabel setFont:[UIFont fontWithName:FontName_Default size:12]];
    [self addSubview:preferentialLabel];
    
    numberLabel = [[UILabel alloc]init];
    [numberLabel setTextColor:COLOR_898989];
    [numberLabel setFont:[UIFont fontWithName:FontName_Default size:12]];
    [self addSubview:numberLabel];
    
    iconRMB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-rmb"]];
    [self addSubview:iconRMB];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(ViewIndentation, labelHeight, ScreenWidth-ViewIndentation*2, 30)];
    backgroundView.layer.cornerRadius = 2;
    backgroundView.layer.borderWidth = 0.5;
    backgroundView.layer.borderColor = [LINECOLOR_SYSTEM CGColor];
    backgroundView.backgroundColor = UIColorWithRGBA(247, 248, 248, 1);
    [self addSubview:backgroundView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, ViewWidth(backgroundView)-10, ViewHeight(backgroundView))];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.placeholder = @"给商家留言（45字以内）：";
    _textField.font = [UIFont fontWithName:FontName_Default size:14];
    [backgroundView addSubview:_textField];
    
    UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, ViewHeight(self)-10, ScreenWidth, 10)];
    bottomLine.backgroundColor = UIColorWithRGBA(247, 248, 248, 1);
    [self addSubview:bottomLine];
}

/**
 *  刷新展示数据
 */
- (void)reloadDisplayData {
    
    CGFloat topOrigin = 3;
    
    [priceLabel setText:[NSString stringWithFormat:@"%0.1f",[_price floatValue]]];
    
    CGSize priceSize = [priceLabel.text sizeWithFont:priceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, titleHeight)];
    [priceLabel setFrame:CGRectMake(ViewWidth(self)-ViewIndentation-priceSize.width, topOrigin, priceSize.width, titleHeight)];
    
    CGSize iconSize = CGSizeMake(7, 9);
    
    [iconRMB setFrame:CGRectMake(ViewX(priceLabel)-10, (titleHeight-iconSize.height)/2+topOrigin, iconSize.width, iconSize.height)];
    
    [numberLabel setText:[NSString stringWithFormat:@"小计(共%@件):",_number]];
    
    CGSize numberSize = [numberLabel.text sizeWithFont:numberLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, titleHeight)];
    [numberLabel setFrame:CGRectMake(ViewX(iconRMB)-numberSize.width-4, topOrigin, numberSize.width, titleHeight)];
    
  
    if (![self isBlankString:_preferential]) {
          [preferentialLabel setText:[NSString stringWithFormat:@"优惠:-%@",_preferential]];
        }
    [preferentialLabel setFrame:CGRectMake(ViewIndentation, topOrigin, 100, titleHeight)];
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"0"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}
@end
