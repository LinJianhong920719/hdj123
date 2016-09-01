//
//  ConfirmSectionHeaderView.m
//  MailWorldClient
//
//  Created by yusaiyan on 15/11/4.
//  Copyright © 2015年 QunYu_TD. All rights reserved.
//

#import "ConfirmSectionHeaderView.h"
#import "AppConfig.h"

#define viewIndentation     20      //视图两边缩进

@implementation ConfirmSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self drawRectView:self.frame];
    }
    
    return self;
}

/**
 *  绘制初始视图
 */
- (void)drawRectView:(CGRect)rect {
    
    UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(viewIndentation, ViewHeight(self), ScreenWidth-viewIndentation*2, 0.5)];
    bottomLine.backgroundColor = LINECOLOR_SYSTEM;
    [self addSubview:bottomLine];

    CGSize logoSize = CGSizeMake(20, 20);
    CGSize arrowSize = CGSizeMake(7, 11);
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(viewIndentation, (ViewHeight(self)-logoSize.height)/2, logoSize.width, logoSize.height)];
    logo.image = [UIImage imageNamed:@"store.png"];
    [self addSubview:logo];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-viewIndentation-arrowSize.width, (ViewHeight(self)-arrowSize.height)/2, arrowSize.width, arrowSize.height)];
    arrow.image = [UIImage imageNamed:@"address_go.png"];
    [self addSubview:arrow];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(viewRight(logo)+10, 0, ViewX(arrow)-viewRight(logo), ViewHeight(self))];
    _title.textColor = COLOR_898989;
    _title.font = [UIFont fontWithName:FontName_Default size:14];
    [self addSubview:_title];
    
    _button = [[UIButton alloc]initWithFrame:self.frame];
    [self addSubview:_button];
}

/**
 *  刷新展示数据
 */
- (void)reloadDisplayData {
    
}

@end
