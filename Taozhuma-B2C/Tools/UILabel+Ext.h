//
//  UILabel+Ext.h
//  GroupPurchase
//
//  Created by yusaiyan on 16/12/21.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Ext)

/**
 设置UILabel行/字间距
 
 @param label 目标对象
 @param lineSpacing 行距
 @param kerning 字距
 */
+ (void)setLabelSpace:(UILabel*)label lineSpacing:(CGFloat)lineSpacing kerning:(CGFloat)kerning;

/**
 计算UILabel的高度
 
 @param label 目标对象
 @param width 目标宽度
 @return
 */
+ (CGFloat)getLabelHeight:(UILabel *)label withWidth:(CGFloat)width;

/**
 计算UILabel的高度(并设置行/字间距)
 
 @param label 目标对象
 @param width 目标宽度
 @param lineSpacing 设置行距
 @param kerning 设置字距
 @return
 */
+ (CGFloat)getLabelHeight:(UILabel *)label withWidth:(CGFloat)width lineSpacing:(CGFloat)lineSpacing kerning:(CGFloat)kerning;


+ (NSDictionary *)getMutableParagraphStyleDic:(UILabel *)label lineSpacing:(CGFloat)lineSpacing kerning:(CGFloat)kerning;

@end
