//
//  UIColor+Hex.h
//  MailWorldClient
//
//  Created by yusaiyan on 16/9/20.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

//16进制RGB的颜色转换
#define ColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//R G B 颜色
#define ColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define UIColorWithRGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//#define RGB(r, g, b)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define COLOR_262626                RGB(38, 38, 38)
#define COLOR_343434                RGB(52, 52, 52)
#define COLOR_3E3A39                RGB(62, 58, 57)
#define COLOR_46D232                RGB(70, 210, 50)
#define COLOR_474647                RGB(71, 70, 71)
#define COLOR_595757                RGB(89, 87, 87)
#define COLOR_666464                RGB(102, 100, 100)
#define COLOR_666666                RGB(102, 102, 102)
#define COLOR_707070                RGB(112, 112, 112)
#define COLOR_7DCDF3                RGB(125, 205, 243)
#define COLOR_842302                RGB(132, 35, 2)
#define COLOR_898989                RGB(137, 137, 137)
#define COLOR_9FA0A0                RGB(159, 160, 160)
#define COLOR_C8C8C8                RGB(200, 200, 200)
#define COLOR_DCDCDC                RGB(220, 220, 220)
#define COLOR_E61D58                RGB(230, 29, 88)
#define COLOR_E73C7B                RGB(231, 60, 123)
#define COLOR_EB4B82                RGB(235, 75, 130)
#define COLOR_EEEFEF                RGB(238, 239, 239)
#define COLOR_F2F2F2                RGB(242, 242, 242)
#define COLOR_F7F8F8                RGB(247, 248, 248)


#define LINECOLOR_SYSTEM            COLOR_C8C8C8
#define LINECOLOR_DEFAULT           COLOR_DCDCDC
#define BGCOLOR_DEFAULT             COLOR_EEEFEF
#define THEME_COLORS_RED            COLOR_E61D58
#define FONT_COLOR                  COLOR_262626
#define FONTS_COLOR                 COLOR_898989

@interface UIColor (Hex)

+ (UIColor *)randomColor;

+ (UIColor *)colorWithHex:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHex:(NSString *)color alpha:(CGFloat)alpha;

@end
