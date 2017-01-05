//
//  MainNavBar.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 17/1/5.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavBar : UIView
{
@protected
    
    UIImageView *loactionIV;
    UIImageView *arrowIV;
    UILabel *loactionLabel;
    UIButton *loactionBtn;
    UIButton *serachBtn;
}

/** 定位按钮点击回调 */
@property (nonatomic, copy) void (^loactionClickBlock)();
/** 搜索按钮点击回调 */
@property (nonatomic, copy) void (^searchClickBlock)();

/**
 显示当前位置

 @param str 地点
 */
- (void)setLoactionName:(NSString *)str;

@end
