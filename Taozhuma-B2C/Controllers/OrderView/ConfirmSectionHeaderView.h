//
//  ConfirmSectionHeaderView.h
//  MailWorldClient
//
//  Created by yusaiyan on 15/11/4.
//  Copyright © 2015年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmSectionHeaderView : UIView

@property (nonatomic, strong) UIButton  *button;
@property (nonatomic, strong) UILabel   *title;        //标题

- (void)reloadDisplayData;

@end
