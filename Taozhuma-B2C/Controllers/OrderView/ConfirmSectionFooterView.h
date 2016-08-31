//
//  ConfirmSectionFooterView.h
//  MailWorldClient
//
//  Created by yusaiyan on 15/11/4.
//  Copyright © 2015年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmSectionFooterView : UIView

@property (nonatomic, strong) UITextField   *textField;     //输入框

@property (nonatomic, strong) NSString      *price;         //小计金额
@property (nonatomic, strong) NSString      *number;        //小计数量
@property (nonatomic, strong) NSString      *preferential;  //优惠金额

- (void)reloadDisplayData;

@end
