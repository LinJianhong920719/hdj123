//
//  TakeOutCell.h
//  附近外卖Cell
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainProductEntity.h"
#import "BaseViewController.h"

#define CellIdentifier @"MainViewCell"

@interface MainViewCell : UITableViewCell

@property (strong, nonatomic) BaseViewController *viewController;

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;//标题前面的颜色条
@property (weak, nonatomic) IBOutlet UILabel *titleName;//标题名称
@property (weak, nonatomic) IBOutlet UIButton *classBtn;

@property (weak, nonatomic) IBOutlet UIImageView *advImage;//广告image
@property (weak, nonatomic) IBOutlet UIImageView *fristProductImage;//第一个产品图片
@property (weak, nonatomic) IBOutlet UILabel *firstProductName;//第一个产品名称
@property (weak, nonatomic) IBOutlet UILabel *firstProductPirce;//第一个产品价格
@property (weak, nonatomic) IBOutlet UIButton *firstProductBtn;//第一个产品按钮

@property (weak, nonatomic) IBOutlet UIImageView *secondProductImage;//第二个产品图片
@property (weak, nonatomic) IBOutlet UILabel *secondProductName;//第二个产品名称
@property (weak, nonatomic) IBOutlet UILabel *secondProductPrice;//第二个产品价格
@property (weak, nonatomic) IBOutlet UIButton *secondProductBtn;//第二个产品按钮

@property (weak, nonatomic) IBOutlet UIImageView *thirdProductImage;//第叁个产品图片
@property (weak, nonatomic) IBOutlet UILabel *thirdProductName;//第叁个产品名称
@property (weak, nonatomic) IBOutlet UILabel *thirdProductPrice;//第叁个产品价格
@property (weak, nonatomic) IBOutlet UIButton *thirdProductBtn;//第叁个产品按钮

- (void)configWith:(MainProductEntity *)model;

@end
