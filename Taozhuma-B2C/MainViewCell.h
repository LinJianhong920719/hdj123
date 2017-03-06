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

@property (weak, nonatomic) IBOutlet UIImageView *fourProductImage;//第四个产品图片
@property (weak, nonatomic) IBOutlet UILabel *fourProductName;//第四个产品名称
@property (weak, nonatomic) IBOutlet UILabel *fourProductPrice;//第四个产品价格
@property (weak, nonatomic) IBOutlet UIButton *fourProductBtn;//第四个产品按钮

@property (weak, nonatomic) IBOutlet UIImageView *fiveProductImage;//第五个产品图片
@property (weak, nonatomic) IBOutlet UILabel *fiveProductName;//第五个产品名称
@property (weak, nonatomic) IBOutlet UILabel *fiveProductPrice;//第五个产品价格
@property (weak, nonatomic) IBOutlet UIButton *fiveProductBtn;//第五个产品按钮

@property (weak, nonatomic) IBOutlet UIImageView *sixProductImage;//第六个产品图片
@property (weak, nonatomic) IBOutlet UILabel *sixProductName;//第六个产品名称
@property (weak, nonatomic) IBOutlet UILabel *sixProductPrice;//第六个产品价格
@property (weak, nonatomic) IBOutlet UIButton *sixProductBtn;//第六个产品按钮

@property (weak, nonatomic) IBOutlet UIImageView *sevenProductImage;//第七个产品图片
@property (weak, nonatomic) IBOutlet UILabel *sevenProductName;//第七个产品名称
@property (weak, nonatomic) IBOutlet UILabel *sevenProductPrice;//第七个产品价格
@property (weak, nonatomic) IBOutlet UIButton *sevenProductBtn;//第七个产品按钮

@property (weak, nonatomic) IBOutlet UIImageView *eightProductImage;//第八个产品图片
@property (weak, nonatomic) IBOutlet UILabel *eightProductName;//第八个产品名称
@property (weak, nonatomic) IBOutlet UILabel *eightProductPrice;//第八个产品价格
@property (weak, nonatomic) IBOutlet UIButton *eightProductBtn;//第八个产品按钮

@property (weak, nonatomic) IBOutlet UIImageView *nineProductImage;//第九个产品图片
@property (weak, nonatomic) IBOutlet UILabel *nineProductName;//第九个产品名称
@property (weak, nonatomic) IBOutlet UILabel *nineProductPrice;//第九个产品价格
@property (weak, nonatomic) IBOutlet UIButton *nineProductBtn;//第九个产品按钮

- (void)configWith:(MainProductEntity *)model;

@end
