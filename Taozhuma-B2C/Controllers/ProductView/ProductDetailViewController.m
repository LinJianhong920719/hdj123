//
//  ProductDetailViewController.m
//
//
//  Created by Average on 16/8/23.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "WHCircleImageView.h"

@interface ProductDetailViewController ()<UIActionSheetDelegate>{
    UIView * topsView;
    WHCircleImageView *circleImageView;
    NSArray *pictureUrlArray;
    UIScrollView *_scrollView;
    NSString *goodtName;
    NSString *goodtPrice;
    Boolean isCollect;
    NSString *shopNameStr;
    NSString *goodsSizeStr;
    NSString *goodsDateStr;
    NSString *goodsMsgStr;
    NSString *mode;
    UIButton *collectBtn;
}

@end

@implementation ProductDetailViewController
@synthesize goodId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBanner];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    //底层View
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ViewOrignY, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT)];
    _scrollView.backgroundColor = LINECOLOR_DEFAULT;
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scrollView];
    //广告图数据
    NSLog(@"123:%@",pictureUrlArray);
    
    topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_WIDTH*0.89+55)];
    [topsView setBackgroundColor:[UIColor whiteColor]];
    //广告图view
    circleImageView = [[WHCircleImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_WIDTH*0.89) AndImageUrlArray:pictureUrlArray view:topsView];
    
    UIView *proView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(circleImageView), DEVICE_SCREEN_SIZE_WIDTH, 55)];
    
    [topsView addSubview:proView];
    
    UILabel *pName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, DEVICE_SCREEN_SIZE_WIDTH-80, 15)];
    if ([self isBlankString:goodtName]) {
        pName.text = @"好当家";
    }else{
        pName.text = goodtName;
    }
    
    pName.font = [UIFont systemFontOfSize:12];
    pName.textColor = FONTS_COLOR51;
    [proView addSubview:pName];
    
    UILabel *pPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, viewBottom(pName)+5, DEVICE_SCREEN_SIZE_WIDTH-80, 15)];
    if ([self isBlankString:goodtPrice]) {
        pPrice.text = @"$0.00";
    }else{
        pPrice.text = goodtPrice;
    }
    
    pPrice.font = [UIFont systemFontOfSize:12];
    pPrice.textColor = [UIColor colorWithRed:255/255.0f green:80/255.0f blue:0 alpha:1.0];
    [proView addSubview:pPrice];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH*0.83, 10, 1, 35)];
    line.backgroundColor = FONTS_COLOR153;
    [proView addSubview:line];
    
    collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(line)+9, 15, 30, 30)];
    if (isCollect) {
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"deta_collect_active"] forState:UIControlStateNormal];
    }else{
       [collectBtn setBackgroundImage:[UIImage imageNamed:@"deta_collect"] forState:UIControlStateNormal];
    }
    [collectBtn addTarget:self action:@selector(collectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [proView addSubview:collectBtn];
    
    
    [_scrollView addSubview: topsView];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(topsView)+15, DEVICE_SCREEN_SIZE_WIDTH, 150)];
    
    detailView.backgroundColor = [UIColor whiteColor];
    
    UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 36)];
    shopName.text = @"品牌";
    shopName.textColor = FONTS_COLOR153;
    shopName.textAlignment = NSTextAlignmentRight;
    shopName.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:shopName];
    
    UILabel *shopNameDet = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(shopName)+20, 0, DEVICE_SCREEN_SIZE_WIDTH-70, 36)];
    if ([self isBlankString:shopNameStr]) {
        shopNameDet.text = @"好当家";
        
    }else{
        shopNameDet.text = shopNameStr;
    }
    
    shopNameDet.textColor = FONTS_COLOR51;
    shopNameDet.textAlignment = NSTextAlignmentLeft;
    shopNameDet.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:shopNameDet];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(shopNameDet), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line1.backgroundColor = LINECOLOR_DEFAULT;
    [detailView addSubview:line1];
    
    UILabel *productSize = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line1), 70, 36)];
    productSize.text = @"产品规格";
    productSize.textColor = FONTS_COLOR153;
    productSize.textAlignment = NSTextAlignmentRight;
    productSize.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:productSize];
    
    UILabel *productSizeDet = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(shopName)+20, viewBottom(line1), DEVICE_SCREEN_SIZE_WIDTH-70, 36)];
    if ([self isBlankString:goodsSizeStr]) {
        productSizeDet.text = @"好当家";
    }else{
        productSizeDet.text = shopNameStr;
        
    }
    
    productSizeDet.textColor = FONTS_COLOR51;
    productSizeDet.textAlignment = NSTextAlignmentLeft;
    productSizeDet.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:productSizeDet];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(productSizeDet), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line2.backgroundColor = LINECOLOR_DEFAULT;
    [detailView addSubview:line2];
    
    UILabel *productDate = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(productSize), 70, 36)];
    productDate.text = @"保质期";
    productDate.textColor = FONTS_COLOR153;
    productDate.textAlignment = NSTextAlignmentRight;
    productDate.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:productDate];
    
    UILabel *productDateDet = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(shopName)+20, viewBottom(productSizeDet), DEVICE_SCREEN_SIZE_WIDTH-70, 36)];
    if ([self isBlankString:goodsDateStr]) {
        productDateDet.text = @"好当家";
    }else{
        productDateDet.text = goodsDateStr;
    }
    
    productDateDet.textColor = FONTS_COLOR51;
    productDateDet.textAlignment = NSTextAlignmentLeft;
    productDateDet.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:productDateDet];
    
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(productDateDet), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line3.backgroundColor = LINECOLOR_DEFAULT;
    [detailView addSubview:line3];
    
    UILabel *productMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(productDate), 70, 36)];
    productMsg.text = @"商品简介";
    productMsg.textColor = FONTS_COLOR153;
    productMsg.textAlignment = NSTextAlignmentRight;
    productMsg.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:productMsg];
    
    UILabel *productMsgDet = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(shopName)+20, viewBottom(productDateDet), DEVICE_SCREEN_SIZE_WIDTH-70, 36)];
    if ([self isBlankString:goodsMsgStr]) {
        productMsgDet.text = @"好当家";productMsgDet.text = @"好当家";
    }else{
        productMsgDet.text = goodsMsgStr;
    }
    
    productMsgDet.textColor = FONTS_COLOR51;
    productMsgDet.textAlignment = NSTextAlignmentLeft;
    productMsgDet.font = [UIFont systemFontOfSize:12];
    [detailView addSubview:productMsgDet];
    
    
    [_scrollView addSubview:detailView];
    
    [_scrollView setContentSize:CGSizeMake(DEVICE_SCREEN_SIZE_WIDTH, viewBottom(detailView)+150)];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT-50, DEVICE_SCREEN_SIZE_WIDTH, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIButton *cartBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    [cartBtn setBackgroundImage:[UIImage imageNamed:@"deta_cart"] forState:UIControlStateNormal];
    [bottomView addSubview:cartBtn];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [countLabel setNumberOfLines:0];  //必须是这组值
    NSString *count = @"1";
    countLabel.text = count;
    countLabel.font = [UIFont systemFontOfSize:12];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.backgroundColor = [UIColor colorWithRed:255/255.0f green:80/255.0f blue:0/255.0f alpha:1.0];
    countLabel.textAlignment = NSTextAlignmentCenter;
    
    
    CGSize telSize = [count sizeWithFont:countLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    countLabel.frame = CGRectMake(28, 10, telSize.width+10, telSize.height );
    
    countLabel.layer.cornerRadius = 7;
    countLabel.layer.borderWidth = 0;
    countLabel.layer.masksToBounds = YES;
    [bottomView addSubview:countLabel];
    
    
    UIButton *subBtu = [[UIButton alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH*0.70, 15, 20, 20)];
    [subBtu setBackgroundImage:[UIImage imageNamed:@"minus_active"] forState:UIControlStateNormal];
    [bottomView addSubview:subBtu];
    
    UILabel *noLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(subBtu)+5, 15, 30, 20)];
    noLabel.text = @"0";
    noLabel.textColor = FONTS_COLOR51;
    noLabel.font = [UIFont systemFontOfSize:12];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:noLabel];
    
    UIButton *addBtu = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(noLabel)+5, 15, 20, 20)];
    [addBtu setBackgroundImage:[UIImage imageNamed:@"plus_active"] forState:UIControlStateNormal];
    [bottomView addSubview:addBtu];
    
    [self.view addSubview:bottomView];
    
}
- (IBAction)collectBtn:(id)sender {
    if (isCollect) {
        mode = @"move";
        isCollect = false;
    }else{
        mode = @"add";
        isCollect = true;
    }
    [self doCollectMethod];
}

//获取公告图片
- (void)loadBanner {
    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [NSString stringWithFormat: @"%ld", (long)goodId],   @"goodId",
                          [Tools stringForKey:KEY_USER_ID],  @"userId",
                          nil];
    
    NSString *xpoint = [NSString stringWithFormat:@"/Api/Goods/showDetail?"];
    NSLog(@"dics:%@",dics);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        pictureUrlArray = [[NSMutableArray alloc]init];
        if ([statusMsg intValue] == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        }else if ([statusMsg intValue] == 201){
            [self showHUDText:@"暂无数据"];
        }else if ([statusMsg intValue] == 4002){
            [self showHUDText:@"暂无数据"];
        }else {
            NSString *diss = [[dic valueForKey:@"data"]valueForKey:@"good_image"];
            pictureUrlArray = [diss componentsSeparatedByString:@";"];
            
            goodtName = [[dic valueForKey:@"data"]valueForKey:@"good_name"];
            goodtPrice = [NSString stringWithFormat:@"￥%@",[[dic valueForKey:@"data"]valueForKey:@"good_price"]];
            NSString *colStatus = [[dic valueForKey:@"data"]valueForKey:@"collect_status"];
            if (colStatus.intValue == 1) {
                isCollect = true;
            }else{
                isCollect = false;
            }
            shopNameStr = [[dic valueForKey:@"data"]valueForKey:@"shop_name"];
            goodsSizeStr = [[dic valueForKey:@"data"]valueForKey:@"good_size"];
            goodsDateStr = [[dic valueForKey:@"data"]valueForKey:@"Shelf_life"];
            goodsMsgStr = [[dic valueForKey:@"data"]valueForKey:@"good_introduce"];
            
            [self initUI];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

//收藏与取消收藏操作
- (void)doCollectMethod {
    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [NSString stringWithFormat: @"%ld", (long)goodId],   @"goodId",
                          [Tools stringForKey:KEY_USER_ID],  @"userId",
                          mode,@"mode",
                          nil];
    
    NSString *xpoint = [NSString stringWithFormat:@"/Api/User/collectGoods?"];
    NSLog(@"dics:%@",dics);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        pictureUrlArray = [[NSMutableArray alloc]init];
        if ([statusMsg intValue] == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"操作失败!"];
            
        }else if ([statusMsg intValue] == 201){
            [self showHUDText:@"暂无数据"];
        }else if ([statusMsg intValue] == 4002){
            [self showHUDText:@"暂无数据"];
        }else {
            [self showHUDText:@"操作成功"];
            BOOL isequal = [mode isEqualToString:@"add"];
            if (isequal) {
                [collectBtn setBackgroundImage:[UIImage imageNamed:@"deta_collect_active"] forState:UIControlStateNormal];
            }else{
                [collectBtn setBackgroundImage:[UIImage imageNamed:@"deta_collect"] forState:UIControlStateNormal];
            }
    
        }
        
    } fail:^(NSError *error) {
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
