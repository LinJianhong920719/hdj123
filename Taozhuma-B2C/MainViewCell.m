//
//  MainViewCell.m
//  Cell
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell


@synthesize titleImage;//标题前面的颜色条
@synthesize titleName;//标题名称
@synthesize moreLabel;//更多
@synthesize moreImge;//更多image
@synthesize advImage;//广告image
@synthesize fristProductImage;//第一个产品图片
@synthesize firstProductName;//第一个产品名称
@synthesize firstProductPirce;//第一个产品价格
@synthesize firstAddCartImge;//第一个产品加入购物车
@synthesize secondProductImage;//第二个产品图片
@synthesize secondProductName;//第二个产品名称
@synthesize secondProductPrice;//第二个产品价格
@synthesize secondAddCartImage;//第二个产品加入购物车
@synthesize thirdProductImage;//第叁个产品图片
@synthesize thirdProductName;//第叁个产品名称
@synthesize thirdProductPrice;//第叁个产品价格
@synthesize thirdAddCartImage;//第叁个产品加入购物车
@synthesize moreBtn;
@synthesize firstProductBtn;
@synthesize secondProductBtn;
@synthesize thirdProductBtn;
@synthesize fourProductBtn;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

@end
