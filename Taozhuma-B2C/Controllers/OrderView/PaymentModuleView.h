//
//  PaymentModuleView.h
//  MailWorldClient
//
//  Created by yusaiyan on 15/10/31.
//  Copyright © 2015年 liyoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentModuleDelegate;

@interface PaymentModuleView : UIView

@property (nonatomic, strong) UIButton *vouchersButton;
@property (nonatomic, strong) UILabel *vouchersValue;       //代金券面值

@property (nonatomic, strong) NSString *vouchersNO;         //代金券编号
@property (nonatomic, strong) NSString *vouchersID;         //代金券ID
@property (nonatomic, strong) NSString *payType;            //支付方式

@property (nonatomic, strong) NSString *walletType;          //是否使用钱包
@property (nonatomic, strong) UIButton *walletButton;
@property (nonatomic, strong) UILabel *walletBalance;        //钱包余额

@property (nonatomic, unsafe_unretained) id delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
//是否允许使用钱包
- (void)allowedToUseTheWallet:(BOOL)status;

@end


@protocol PaymentModuleDelegate <NSObject>

@optional

// 返回view实际高度
- (void)paymentModuleView:(PaymentModuleView *)paymentModuleView heightForView:(CGFloat)height;

@end
