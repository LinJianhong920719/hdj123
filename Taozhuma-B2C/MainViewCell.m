//
//  MainViewCell.m
//  Cell
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "MainViewCell.h"
#import "ProductDetailViewController.h"

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

- (void)configWith:(MainProductEntity *)model {
    
    self.titleName.text = model.productTypeName;
    
    //类型商品图片
    if ([Tools isBlankString:model.advProductImage]) {
        self.advImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.advImage sd_setImageWithURL:[NSURL URLWithString:model.advProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    //第一个商品
    /*图片*/
    if ([Tools isBlankString:model.fristProductImage]) {
        self.fristProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.fristProductImage sd_setImageWithURL:[NSURL URLWithString:model.fristProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.firstProductName]) {
        self.firstProductName.text = @"敬请期待";
    } else {
        self.firstProductName.text = model.firstProductName;
    }
    
    if ([Tools isBlankString:model.firstProductPirce]) {
        self.firstProductPirce.text = @"￥0.00";
    } else {
        self.firstProductPirce.text = [NSString stringWithFormat:@"￥%@", model.firstProductPirce];
    }
    
    
    //第二个商品
    /*图片*/
    if ([Tools isBlankString:model.secondProductImage]) {
        self.secondProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.secondProductImage sd_setImageWithURL:[NSURL URLWithString:model.secondProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.secondProductName]) {
        self.secondProductName.text = @"敬请期待";
    } else {
        self.secondProductName.text = model.secondProductName;
    }
    
    if ([Tools isBlankString:model.secondProductPrice]) {
        self.secondProductPrice.text = @"￥0.00";
    } else {
        self.secondProductPrice.text = [NSString stringWithFormat:@"￥%@", model.secondProductPrice];
    }
    
    
    //第三个商品
    /*图片*/
    if ([Tools isBlankString:model.thirdProductImage]) {
        self.thirdProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.thirdProductImage sd_setImageWithURL:[NSURL URLWithString:model.thirdProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.secondProductName]) {
        self.thirdProductName.text = @"敬请期待";
    } else {
        self.thirdProductName.text = model.thirdProductName;
    }
    
    if ([Tools isBlankString:model.secondProductName]) {
        self.thirdProductPrice.text = @"￥0.00";
    } else {
        self.thirdProductPrice.text = [NSString stringWithFormat:@"￥%@", model.thirdProductPrice];
    }
    
    
    [self.moreBtn addTarget:self action:@selector(moreClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.firstProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.firstProductBtn.tag = model.advProductId.intValue;
    
    [self.secondProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.secondProductBtn.tag = model.fristProductId.intValue;
    
    [self.thirdProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.thirdProductBtn.tag = model.secondProductId.intValue;
    
    [self.fourProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.fourProductBtn.tag = model.thirdProductId.intValue;
    
}

#pragma mark -点击事件

//点击更多跳转的页面
- (IBAction)moreClicked:(id)sender {
    //通知 发出
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refSelectedIndex" object:nil];
}

//点击商品跳转商品详情页面
- (IBAction)productClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    ProductDetailViewController *vc = [[ProductDetailViewController alloc]init];
    vc.goodId = btn.tag;
    vc.title = @"商品详情";
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}

@end
