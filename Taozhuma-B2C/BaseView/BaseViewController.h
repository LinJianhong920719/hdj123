//
//  BaseViewController.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "HYBNetworking.h"
#import "CustomViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworkReachabilityManager.h"
#import "SDRefresh.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface BaseViewController : CustomViewController

/**
 *  根据登录状态执行操作 已登录的话执行回调
 *
 *  @param finishBlock 回调
 */
- (void)pushViewControllerByUserLogin:(void(^)(void))finishBlock;

@property (nonatomic, assign) BOOL isBackToroot;

- (BOOL) isBlankString:(NSString *)string;

- (void)startLoading;//开始动画
- (void)endLoading;//结束动画

- (void)startNetwork;//网络中断显示
- (void)endNetwork;//网络中断隐藏
- (void)networkView;//网络中断显示模块布局


@end
