//
//  GuideManager.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/10.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"

@interface GuideManager : NSObject

+ (instancetype)shared;

/**
 *  @author 李欣帆, 16-05-10 11:28:26
 *
 *  显示引导图
 *
 *  @param images 图片集合
 */
- (void)showGuideViewWithImages:(NSArray *)images;

@end
