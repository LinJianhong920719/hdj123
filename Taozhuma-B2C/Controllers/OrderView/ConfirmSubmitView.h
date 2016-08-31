//
//  OrderSubmitView.h
//  MailWorldClient
//
//  Created by yusaiyan on 15/11/3.
//  Copyright © 2015年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmSubmitView : UIView

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, assign) CGFloat total;            //总价
@property (nonatomic, assign) CGFloat freight;          //运费
@property (nonatomic, assign) CGFloat coupons;          //优惠金额
@property (nonatomic, assign) BOOL isRemote;            //是否偏远地区

- (void)reloadDisplayData;

@end
