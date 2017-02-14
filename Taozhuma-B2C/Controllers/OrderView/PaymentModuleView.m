//
//  PaymentModuleView.m
//  MailWorldClient
//
//  Created by yusaiyan on 15/10/31.
//  Copyright © 2015年 liyoro. All rights reserved.
//

#import "PaymentModuleView.h"
#import "AppConfig.h"


#define viewIndentation     20      //视图两边缩进
#define titleHeight         30      //标题部分高度
#define vouchersHeight      45      //优惠券部分高度
#define optionsHeight       40      //支付选项高度
#define additionalTag       99000000
#define alipayType          @"1"    //支付宝支付状态
#define wxpayType           @"2"    //微信支付状态
#define walletType           @"3"    //钱包支付状态

@implementation PaymentModuleView {
    NSArray *data;
    UIView *paymentView;
    CGFloat paymentViewHeight;
    UIView *baseView;
    UIButton *payBtn;
    
}

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate;
        
        _payType = alipayType;
        
        NSDictionary *alipay = [NSDictionary dictionaryWithObjectsAndKeys:@"支付宝" ,@"title", @"安全快捷，可支持银行卡支付", @"content", @"zfb.png", @"imageName", alipayType, @"payType", @"1", @"status",nil];
        NSDictionary *wxpay = [NSDictionary dictionaryWithObjectsAndKeys:@"微信支付" ,@"title", @"推荐已在微信中绑定银行卡的用户使用", @"content", @"wxzf.png", @"imageName", wxpayType, @"payType", @"0", @"status",nil];
        NSDictionary *wallet = [NSDictionary dictionaryWithObjectsAndKeys:@"钱包支付" ,@"title", @"用户钱包支付支付", @"content", @"user_wallet.png", @"imageName", walletType, @"payType", @"0", @"status",nil];
//        NSDictionary *applepay = [NSDictionary dictionaryWithObjectsAndKeys:@"苹果支付" ,@"title", @"applePay快捷支付", @"content", @"apple-pay.png", @"imageName", appleType, @"payType", @"0", @"status",nil];
        
        data = @[alipay, wxpay, wallet];
//        data = @[alipay, wxpay, unionpay, applepay];
//        data = @[alipay, wxpay, applepay];
        [self drawRectView:self.frame];
//        [self drawWalletView];
        [self drawPayView];
        [self userCountView];
    }
    
    return self;
}

/**
 *  绘制初始视图
 */
- (void)drawRectView:(CGRect)rect {
    
    CGSize arrowImageSize       = CGSizeMake(7, 10);
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(viewIndentation, 0, self.frame.size.width, titleHeight)];
    title.text = @"支付方式";
    title.textColor = FONTS_COLOR153;
    title.font = [UIFont fontWithName:FontName_Default_Bold size:10];
    [self addSubview:title];
    
//    _vouchersButton = [[UIButton alloc]initWithFrame:CGRectMake(0, viewBottom(title), ScreenWidth, vouchersHeight)];
//    [self addSubview:_vouchersButton];
//    
//    UILabel *voucherLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewIndentation, 0, self.frame.size.width, vouchersHeight)];
//    voucherLabel.text = @"使用代金券";
//    voucherLabel.font = [UIFont fontWithName:FontName_Default size:14];
//    [_vouchersButton addSubview:voucherLabel];
//    
//    //代金券 抵消面额
//    _vouchersValue = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-viewIndentation*2, vouchersHeight)];
//    _vouchersValue.textAlignment = NSTextAlignmentRight;
//    _vouchersValue.textColor = THEME_COLORS_RED;
//    _vouchersValue.font = [UIFont fontWithName:FontName_Default_Bold size:14];
//    [_vouchersButton addSubview:_vouchersValue];
//    
//    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-viewIndentation-arrowImageSize.width, (_vouchersButton.frame.size.height-arrowImageSize.height)/2, arrowImageSize.width, arrowImageSize.height)];
//    [arrow setImage:[UIImage imageNamed:@"icon-more.png"]];
//    [_vouchersButton addSubview:arrow];
//    
//    UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    topLine.backgroundColor = LINECOLOR_SYSTEM;
//    [_vouchersButton addSubview:topLine];
    
}

/**
 *  绘制钱包视图
 */
- (void)drawWalletView {
    
    _walletButton = [[UIButton alloc]init];
    [_walletButton setImage:[UIImage imageNamed:@"钱包-方框打勾.png"] forState:UIControlStateNormal];
    [_walletButton setImageEdgeInsets:UIEdgeInsetsMake(14.0, 20.0, 15.0, ScreenWidth-35)];
    [_walletButton addTarget:self action:@selector(walletClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_walletButton];
    
    UIImageView *walletImage = [[UIImageView alloc]initWithFrame:CGRectMake(45, 10, 25, 25)];
    walletImage.image = [UIImage imageNamed:@"钱包.png"];
    [_walletButton addSubview:walletImage];
    
    UILabel *walletTitle = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(walletImage)+10, 0, 70, 45)];
    walletTitle.text = @"钱包余额：";
    walletTitle.font = [UIFont fontWithName:FontName_Default size:14];
    [_walletButton addSubview:walletTitle];
    
    //钱包余额
    _walletBalance = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(walletTitle), 0, self.frame.size.width-viewIndentation*2, vouchersHeight)];
    _walletBalance.textColor = THEME_COLORS_RED;
    _walletBalance.font = [UIFont fontWithName:FontName_Default size:14];
    [_walletButton addSubview:_walletBalance];
    
    UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(viewIndentation/2, 0, ScreenWidth-viewIndentation, 0.5)];
    topLine.backgroundColor = LINECOLOR_SYSTEM;
    [_walletButton addSubview:topLine];
    
}

/**
 *  绘制第三方支付视图
 */
- (void)walletClick:(id)sender {
    UIButton *btn = (UIButton *)sender;

    switch ([_walletType integerValue]) {
        case 0:
            _walletType = @"1";
            [btn setImage:[UIImage imageNamed:@"钱包-方框打勾.png"] forState:UIControlStateNormal];
            break;
        case 1:
            _walletType = @"0";
            [btn setImage:[UIImage imageNamed:@"钱包-方框.png"] forState:UIControlStateNormal];
            break;
    }
}

- (void)drawPayView {
    
    paymentView = [[UIView alloc]init];
    [self addSubview:paymentView];
    
    for (int i = 0; i < data.count; i ++) {
        
        CGFloat originY = i * optionsHeight;
        
        NSDictionary *dic = [data objectAtIndex:i];

        UIImageView *payImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, originY+40, 25, 25)];
        payImage.image = [UIImage imageNamed:[dic valueForKey:@"imageName"]];
        [paymentView addSubview:payImage];
        
        UILabel *payTitle = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(payImage)+10, originY+40, ScreenWidth, 25)];
        payTitle.text = [dic valueForKey:@"title"];
        payTitle.font = [UIFont fontWithName:FontName_Default size:14];
        [paymentView addSubview:payTitle];

        
        UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(viewIndentation/2, originY+32, ScreenWidth-viewIndentation, 0.5)];
        topLine.backgroundColor = LINECOLOR_SYSTEM;
        [paymentView addSubview:topLine];
        
        NSString *btnImageName;
        if ([[dic valueForKey:@"status"]boolValue]) {
            btnImageName = @"checkbox_active.png";
        } else {
            btnImageName = @"checkbox.png";
        }
        
        payBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, originY+32, ScreenWidth, optionsHeight)];
        [payBtn setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
        [payBtn setImageEdgeInsets:UIEdgeInsetsMake(10.0, ScreenWidth-38, 10.0, 18.0)];
        [payBtn setTag:additionalTag+i];
       
        [payBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        [paymentView addSubview:payBtn];
        
        paymentViewHeight = viewBottom(payBtn);
    }
    
    [self allowedToUseTheWallet:NO];
    
}
- (void)userCountView {
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(payBtn), ScreenWidth, 10)];
    lineView.backgroundColor = BGCOLOR_DEFAULT;
    [self addSubview:lineView];
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(lineView), ScreenWidth, 80)];
//    baseView.backgroundColor = [UIColor greenColor];
    //优惠券titile
    UILabel *couponsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    couponsLabel.text = @"优惠券";
    couponsLabel.font = [UIFont systemFontOfSize:12.0];
    couponsLabel.textColor = FONTS_COLOR102;
//    couponsLabel.backgroundColor = [UIColor greenColor];
    [baseView addSubview:couponsLabel];
    
    //优惠券数量显示
    _countCoupon = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth*0.60, 0, 100, 40)];
    _countCoupon.text = @"选择优惠券";
    _countCoupon.font = [UIFont systemFontOfSize:12.0];
    _countCoupon.textColor = FONTS_COLOR153;
//    countCoupon.backgroundColor = [UIColor redColor];
    _countCoupon.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:_countCoupon];
    [self addSubview:baseView];
    
    _couponBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 40)];
//    [couponBtn addTarget:self action:@selector(chooseCoupon) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:_couponBtn];
    
    
    //优惠券图片>
    UIImageView *goCoupons = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-25, 15, 7, 10)];

    [goCoupons setImage:[UIImage imageNamed:@"address_go"]];
    [baseView addSubview:goCoupons];
    
    //分割线
    UIImageView *tLine = [[UIImageView alloc]initWithFrame:CGRectMake(viewIndentation/2, viewBottom(couponsLabel), ScreenWidth-viewIndentation, 0.5)];
    tLine.backgroundColor = LINECOLOR_SYSTEM;
    [baseView addSubview:tLine];
    
    
    //余额titile
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, viewBottom(tLine), 100, 40)];
    moneyLabel.text = @"账户余额";
    moneyLabel.font = [UIFont systemFontOfSize:12.0];
    moneyLabel.textColor = FONTS_COLOR102;
    //    couponsLabel.backgroundColor = [UIColor greenColor];
    [baseView addSubview:moneyLabel];
    
    //余额数量显示
    _money = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth*0.60, viewBottom(tLine), 100, 40)];
    _money.text = @"***";
    _money.font = [UIFont systemFontOfSize:12.0];
    _money.textColor = FONTS_COLOR153;
//        money.backgroundColor = [UIColor redColor];
    _money.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:_money];
    [self addSubview:baseView];
    
    //go优惠券
    UIImageView *goMoney = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-25, viewBottom(tLine)+15, 7, 10)];
    
    [goMoney setImage:[UIImage imageNamed:@"address_go"]];
    [baseView addSubview:goMoney];
    
//    //分割线
//    UIImageView *tLine = [[UIImageView alloc]initWithFrame:CGRectMake(viewIndentation/2, viewBottom(goCoupons)+5, ScreenWidth-viewIndentation, 0.5)];
//    tLine.backgroundColor = LINECOLOR_SYSTEM;
//    [baseView addSubview:tLine];
    
    paymentViewHeight = viewBottom(baseView);

}
- (void)payClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    //所有按钮改变为未点击状态
    for (int i = 0; i < data.count; i ++) {
        UIButton *button = [self viewWithTag:i + additionalTag];
        [button setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    
    //当前按钮变为点击状态
    [btn setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal];
    
    NSDictionary *dic = [data objectAtIndex:btn.tag-additionalTag];
    _payType = [dic valueForKey:@"payType"];
    NSLog(@"_payType =======>> %@",_payType);
}

/**
 * 是否可以使用钱包
 */
- (void)allowedToUseTheWallet:(BOOL)status {
    if (status) {
        _walletType = @"1";
        
        _walletButton.hidden = NO;
        _walletButton.frame = CGRectMake(0, viewBottom(_vouchersButton), ScreenWidth, vouchersHeight);
        paymentView.frame = CGRectMake(0, viewBottom(_walletButton), ScreenWidth, paymentViewHeight);
    } else {
        _walletType = @"0";
        
        _walletButton.hidden = YES;
        paymentView.frame = CGRectMake(0, viewBottom(_vouchersButton), ScreenWidth, paymentViewHeight);
    }
    
    self.frame = CGRectMake(0, ViewY(self), ViewWidth(self), viewBottom(paymentView));
    
    if ([_delegate respondsToSelector:@selector(paymentModuleView:heightForView:)]) {
        [_delegate paymentModuleView:self heightForView:ViewHeight(self)];
    }
    
}


@end
