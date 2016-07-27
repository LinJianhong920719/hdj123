//
//  MineOrderCellView.h
//  MailWorldClient
//
//  Created by yusaiyan on 16/4/8.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineOrderDelegate;

@interface MineOrderCellView : UIView

@property (nonatomic, unsafe_unretained) id<MineOrderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Delegated:(id)delegate;

- (void)refreshMessages:(NSArray *)array;

@end

@protocol MineOrderDelegate <NSObject>

@optional

/**
 *  加入购物车
 *
 *  @param shoppingCartView     执行对象
 *  @param boolean              是否允许执行
 */
- (void)orderCellView:(MineOrderCellView *)mineOrderCellView clickButton:(UIButton *)button title:(NSString *)title;

@end