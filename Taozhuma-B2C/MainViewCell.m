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
@synthesize classBtn;

@synthesize advImage;//广告image
@synthesize fristProductImage;//第一个产品图片
@synthesize firstProductName;//第一个产品名称
@synthesize firstProductPirce;//第一个产品价格
@synthesize firstProductBtn;

@synthesize secondProductImage;//第二个产品图片
@synthesize secondProductName;//第二个产品名称
@synthesize secondProductPrice;//第二个产品价格
@synthesize secondProductBtn;

@synthesize thirdProductImage;//第叁个产品图片
@synthesize thirdProductName;//第叁个产品名称
@synthesize thirdProductPrice;//第叁个产品价格
@synthesize thirdProductBtn;

@synthesize fourProductImage;//第四个产品图片
@synthesize fourProductName;//第四个产品名称
@synthesize fourProductPrice;//第四个产品价格
@synthesize fourProductBtn;//第四个产品按钮

@synthesize fiveProductImage;//第五个产品图片
@synthesize fiveProductName;//第五个产品名称
@synthesize fiveProductPrice;//第五个产品价格
@synthesize fiveProductBtn;//第五个产品按钮

@synthesize sixProductImage;//第六个产品图片
@synthesize sixProductName;//第六个产品名称
@synthesize sixProductPrice;//第六个产品价格
@synthesize sixProductBtn;//第六个产品按钮

@synthesize sevenProductImage;//第七个产品图片
@synthesize sevenProductName;//第七个产品名称
@synthesize sevenProductPrice;//第七个产品价格
@synthesize sevenProductBtn;//第七个产品按钮

@synthesize eightProductImage;//第八个产品图片
@synthesize eightProductName;//第八个产品名称
@synthesize eightProductPrice;//第八个产品价格
@synthesize eightProductBtn;//第八个产品按钮

@synthesize nineProductImage;//第九个产品图片
@synthesize nineProductName;//第九个产品名称
@synthesize nineProductPrice;//第九个产品价格
@synthesize nineProductBtn;//第九个产品按钮







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
    
    if ([Tools isBlankString:model.thirdProductPrice]) {
        self.thirdProductPrice.text = @"￥0.00";
    } else {
        self.thirdProductPrice.text = [NSString stringWithFormat:@"￥%@", model.thirdProductPrice];
    }
    //第四个商品
    /*图片*/
    if ([Tools isBlankString:model.fourProductImage]) {
        self.fourProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.fourProductImage sd_setImageWithURL:[NSURL URLWithString:model.fourProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.fourProductName]) {
        self.fourProductName.text = @"敬请期待";
    } else {
        self.fourProductName.text = model.fourProductName;
    }
    
    if ([Tools isBlankString:model.fourProductPrice]) {
        self.fourProductPrice.text = @"￥0.00";
    } else {
        self.fourProductPrice.text = [NSString stringWithFormat:@"￥%@", model.fourProductPrice];
    }
    //第五个商品
    /*图片*/
    if ([Tools isBlankString:model.fiveProductImage]) {
        self.fiveProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.fiveProductImage sd_setImageWithURL:[NSURL URLWithString:model.fiveProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.fiveProductName]) {
        self.fiveProductName.text = @"敬请期待";
    } else {
        self.fiveProductName.text = model.fiveProductName;
    }
    
    if ([Tools isBlankString:model.fiveProductPrice]) {
        self.fiveProductPrice.text = @"￥0.00";
    } else {
        self.fiveProductPrice.text = [NSString stringWithFormat:@"￥%@", model.fiveProductPrice];
    }
    //第6个商品
    /*图片*/
    if ([Tools isBlankString:model.sixProductImage]) {
        self.sixProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.sixProductImage sd_setImageWithURL:[NSURL URLWithString:model.sixProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.sixProductName]) {
        self.sixProductName.text = @"敬请期待";
    } else {
        self.sixProductName.text = model.sixProductName;
    }
    
    if ([Tools isBlankString:model.sixProductPrice]) {
        self.sixProductPrice.text = @"￥0.00";
    } else {
        self.sixProductPrice.text = [NSString stringWithFormat:@"￥%@", model.sixProductPrice];
    }
    //第7个商品
    /*图片*/
    if ([Tools isBlankString:model.sevenProductImage]) {
        self.sevenProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.sevenProductImage sd_setImageWithURL:[NSURL URLWithString:model.sevenProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.sevenProductName]) {
        self.sevenProductName.text = @"敬请期待";
    } else {
        self.sevenProductName.text = model.sevenProductName;
    }
    
    if ([Tools isBlankString:model.sevenProductPrice]) {
        self.sevenProductPrice.text = @"￥0.00";
    } else {
        self.sevenProductPrice.text = [NSString stringWithFormat:@"￥%@", model.sevenProductPrice];
    }
    //第8个商品
    /*图片*/
    if ([Tools isBlankString:model.eightProductImage]) {
        self.eightProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.eightProductImage sd_setImageWithURL:[NSURL URLWithString:model.eightProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.eightProductName]) {
        self.eightProductName.text = @"敬请期待";
    } else {
        self.eightProductName.text = model.eightProductName;
    }
    
    if ([Tools isBlankString:model.eightProductPrice]) {
        self.eightProductPrice.text = @"￥0.00";
    } else {
        self.eightProductPrice.text = [NSString stringWithFormat:@"￥%@", model.eightProductPrice];
    }
    //第9个商品
    /*图片*/
    if ([Tools isBlankString:model.nineProductImage]) {
        self.nineProductImage.image = [UIImage imageNamed:@"暂无图片"];
    } else {
        [self.nineProductImage sd_setImageWithURL:[NSURL URLWithString:model.nineProductImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    if ([Tools isBlankString:model.nineProductName]) {
        self.nineProductName.text = @"敬请期待";
    } else {
        self.nineProductName.text = model.nineProductName;
    }
    
    if ([Tools isBlankString:model.nineProductPrice]) {
        self.nineProductPrice.text = @"￥0.00";
    } else {
        self.nineProductPrice.text = [NSString stringWithFormat:@"￥%@", model.nineProductPrice];
    }

    
    
    
    
    [self.classBtn addTarget:self action:@selector(moreClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.firstProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.firstProductBtn.tag = model.fristProductId.intValue;
    
    [self.secondProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.secondProductBtn.tag = model.secondProductId.intValue;
    
    [self.thirdProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.thirdProductBtn.tag = model.thirdProductId.intValue;
    
    [self.fourProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.fourProductBtn.tag = model.fourProductId.intValue;
    
    [self.fiveProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.fiveProductBtn.tag = model.fiveProductId.intValue;
    
    [self.sixProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.sixProductBtn.tag = model.sixProductId.intValue;
    
    [self.sevenProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.sevenProductBtn.tag = model.sevenProductId.intValue;
    
    [self.eightProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.eightProductBtn.tag = model.eightProductId.intValue;
    
    [self.nineProductBtn addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.nineProductBtn.tag = model.nineProductId.intValue;
    
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
