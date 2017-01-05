//
//  UILabel+Ext.m
//  GroupPurchase
//
//  Created by yusaiyan on 16/12/21.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "UILabel+Ext.h"

@implementation UILabel (Ext)

+ (void)setLabelSpace:(UILabel*)label lineSpacing:(CGFloat)lineSpacing kerning:(CGFloat)kerning {
    
    NSDictionary *dic = [self getMutableParagraphStyleDic:label lineSpacing:lineSpacing kerning:kerning];
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:label.text attributes:dic];
    label.attributedText = attributeStr;
    
}

+ (CGFloat)getLabelHeight:(UILabel *)label withWidth:(CGFloat)width {
    return [self getLabelHeight:label withWidth:width lineSpacing:.0f kerning:.0f];
}

+ (CGFloat)getLabelHeight:(UILabel *)label withWidth:(CGFloat)width lineSpacing:(CGFloat)lineSpacing kerning:(CGFloat)kerning {
    
    NSDictionary *dic = [self getMutableParagraphStyleDic:label lineSpacing:lineSpacing kerning:kerning];
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:label.text attributes:dic];
    label.attributedText = attributeStr;
    
    //计算高度
    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(width, [[UIScreen mainScreen]bounds].size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return rect.size.height;
    
}

+ (NSDictionary *)getMutableParagraphStyleDic:(UILabel *)label lineSpacing:(CGFloat)lineSpacing kerning:(CGFloat)kerning {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;    

    NSNumber *kerningStr = [NSNumber numberWithFloat:kerning];
    
    NSDictionary *dic = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:kerningStr
                          };
    DLog(@"dic ==== %@", dic);
    return dic;
}

@end
