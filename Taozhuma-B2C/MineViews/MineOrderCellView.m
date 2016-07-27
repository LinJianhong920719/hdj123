//
//  MineOrderCellView.m
//  MailWorldClient
//
//  Created by yusaiyan on 16/4/8.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "MineOrderCellView.h"
#import "AppConfig.h"

#define messageCountTag 409100502

#define margin 8

@implementation MineOrderCellView {
    UILabel *messageCountLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame Delegated:(id)delegate {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.delegate = delegate;
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, margin, ViewWidth(self), 44)];
//        headerView.backgroundColor = RGB(250, 250, 250);
        headerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:headerView];
    
        [self initHeaderViewContent:headerView];
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(headerView), ViewWidth(self), 64)];
//        footerView.backgroundColor = RGB(250, 250, 250);
        footerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:footerView];
        
        [self initFooterViewContent:footerView withArray:[self loadData]];
        
        self.frame = CGRectMake(0, 0, ScreenWidth, viewBottom(footerView) + margin);
        
    }
    
    return self;
}

- (NSArray *)loadData {
    
    NSDictionary *dic01 = [[NSDictionary alloc]initWithObjectsAndKeys:@"待付款", @"title", @"order_noPay", @"iconImage", @"1", @"tpye", nil];
//    NSDictionary *dic02 = [[NSDictionary alloc]initWithObjectsAndKeys:@"待发货", @"title", @"mine_order_delivery", @"iconImage", @"2", @"tpye", nil];
    NSDictionary *dic03 = [[NSDictionary alloc]initWithObjectsAndKeys:@"待收货", @"title", @"order_delivery", @"iconImage", @"3", @"tpye", nil];
    NSDictionary *dic04 = [[NSDictionary alloc]initWithObjectsAndKeys:@"待评价", @"title", @"order_noevaluate", @"iconImage", @"4", @"tpye", nil];
    NSDictionary *dic05 = [[NSDictionary alloc]initWithObjectsAndKeys:@"我的售后", @"title", @"order_quality", @"iconImage", @"5", @"tpye", nil];
    
    return @[dic01, dic03, dic04, dic05];
    
}

- (void)initHeaderViewContent:(UIView *)view {
    
    CGSize size = CGSizeMake(22, 22);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (ViewHeight(view)-size.height)/2, size.width, size.height)];
    imageView.image = [UIImage imageNamed:@"order_all"];
    [view addSubview:imageView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(imageView)+10, 0, 200, ViewHeight(view))];
    title.font = [UIFont fontWithName:FontName_Default size:15];
    title.textColor = COLOR_3E3A39;
    title.text = @"我的订单";
    [view addSubview:title];
    
    CGSize arrowSize = CGSizeMake(7, 16);
    
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth(view)-20, (ViewHeight(view)-arrowSize.height)/2, arrowSize.width, arrowSize.height)];
    arrowImage.image = [UIImage imageNamed:@"more2"];
    [view addSubview:arrowImage];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(15, ViewHeight(view)-0.5, ViewWidth(view)-30, 0.5)];
    lineView.backgroundColor = COLOR_C8C8C8;
    [view addSubview:lineView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:view.frame];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:0];
    [view addSubview:button];
    
}

- (void)initFooterViewContent:(UIView *)view withArray:(NSArray *)array {
    
    float btnSizeWidth = ViewWidth(view) / array.count;
    float btnSizeHeight = ViewHeight(view);
    float horizontalInsets = (ViewWidth(view) / array.count - 22) / 2;
    
    for (int i = 0; i < array.count; i ++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(btnSizeWidth * i, 0, btnSizeWidth, btnSizeHeight)];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:[array[i] valueForKey:@"iconImage"]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(14, horizontalInsets, btnSizeHeight-14-18, horizontalInsets)];
        [button setTag:i+1];
        [view addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(btnSizeWidth * i, 34, btnSizeWidth, 22)];
        [label setFont:[UIFont fontWithName:FontName_Default size:11]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:COLOR_707070];
        [label setText:[array[i] valueForKey:@"title"]];
        [view addSubview:label];
        
        UILabel *mesCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnSizeWidth * (i+1) - PROPORTION414*40, 8, 14, 14)];
        mesCountLabel.font = [UIFont fontWithName:FontName_Default size:9];
        mesCountLabel.textAlignment = NSTextAlignmentCenter;
        mesCountLabel.textColor = THEME_COLORS_RED;
        mesCountLabel.layer.cornerRadius = 7;
        mesCountLabel.layer.masksToBounds = YES;
        mesCountLabel.layer.borderWidth = 0.5;
        mesCountLabel.layer.borderColor = THEME_COLORS_RED.CGColor;
        mesCountLabel.backgroundColor = view.backgroundColor;
        mesCountLabel.hidden = YES;
        mesCountLabel.tag = i + messageCountTag;
        [view addSubview:mesCountLabel];
    }
    
}

- (void)click:(UIButton *)button {

    NSString *title;
    switch (button.tag) {
        case 0: {
            title = @"全部订单";
        }   break;
        case 1: {
            title = @"待付款";
        }   break;
            
        case 2: {
            title = @"待发货";
        }   break;
            
        case 3: {
            title = @"待收货";
        }   break;
            
        case 4: {
            title = @"待评价";
        }   break;
            
        case 5: {
            title = @"退款维权";
        }   break;

        default:
            break;
    }
    
    if (!_delegate) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(orderCellView:clickButton:title:)]) {
        [_delegate orderCellView:self clickButton:button title:title];
    }
    
}

- (void)refreshMessages:(NSArray *)array {
    
    for (int i = 0; i < array.count; i ++) {
        messageCountLabel = (UILabel *)[self viewWithTag:i + messageCountTag];
        messageCountLabel.text = array[i];
        
        if ([array[i] integerValue] > 0) {
            messageCountLabel.hidden = NO;
        } else {
            messageCountLabel.hidden = YES;
        }
    }
    
}

@end
