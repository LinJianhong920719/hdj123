//
//  CartCell.h
//  购物车列表cell
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//
#import "AppConfig.h"
#import "TableViewCell.h"
#import "EMAsyncImageView.h"
//#import "DiscountsShopEntity.h"
//#import "MailWorldRequest.h"
//#import "MBProgressHUD.h"

@interface CartCell :TableViewCell <UITextFieldDelegate> {
//MBProgressHUD *HUD;// 成员变量
}

@property (assign, nonatomic) NSInteger i;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *attribute;
@property (nonatomic, strong) IBOutlet UILabel *price;
@property (nonatomic, strong) IBOutlet UILabel *activityType;
@property (nonatomic, strong) IBOutlet EMAsyncImageView *imagesView;
@property (nonatomic, strong) IBOutlet UILabel *subtotal;
@property (nonatomic, strong) IBOutlet UITextField *number;
@property (nonatomic, strong) IBOutlet UIButton *choose;
@property (nonatomic, strong) IBOutlet UIButton *delBtn;
@property (nonatomic, strong) IBOutlet UIButton *reduceBtn;
@property (nonatomic, strong) IBOutlet UIButton *increaseBtn;
@property (nonatomic, strong) IBOutlet UIView *transparent;
@property (nonatomic, strong) IBOutlet UILabel *prompt;
@property (nonatomic, strong) IBOutlet EMAsyncImageView *promptImages;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *chooseTag;

@property (nonatomic, assign) float subtotalInt;
@property (nonatomic, assign) float priceFloat;
@property (nonatomic, assign) NSString *inventory;

- (void)setChecked:(BOOL)checked;

@end
