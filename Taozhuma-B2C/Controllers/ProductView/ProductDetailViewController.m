//
//  ProductDetailViewController.m
//
//
//  Created by Average on 16/8/23.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "WHCircleImageView.h"
#import "RegisterViewControllerNew.h"

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
    NSString *cartNum;
    UILabel *noLabel;
    UILabel *countLabel;
    NSString *shopId;
    NSString *pMode;
    NSString *count;
    NSString *cartTNum;
    UIView *baseView;
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
    [cartBtn addTarget:self action:@selector(cartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cartBtn];
    
    //购物车数量显示
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [countLabel setNumberOfLines:0];  //必须是这组值
    
    count = [NSString stringWithFormat: @"%@",cartNum];
    
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
    
    //减号按钮
    UIButton *subBtu = [[UIButton alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH*0.70, 15, 20, 20)];
    [subBtu setBackgroundImage:[UIImage imageNamed:@"minus_active"] forState:UIControlStateNormal];
    [subBtu addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    subBtu.tag = 1;
    [bottomView addSubview:subBtu];
    
    //中间数量显示
    noLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(subBtu)+5, 15, 30, 20)];
    noLabel.text = [NSString stringWithFormat: @"%@",cartTNum];;
    noLabel.textColor = FONTS_COLOR51;
    noLabel.font = [UIFont systemFontOfSize:12];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:noLabel];
    
    //加号按钮
    UIButton *addBtu = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(noLabel)+5, 15, 20, 20)];
    [addBtu setBackgroundImage:[UIImage imageNamed:@"plus_active"] forState:UIControlStateNormal];
    [addBtu addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    addBtu.tag = 2;
    [bottomView addSubview:addBtu];
    
    [self.view addSubview:bottomView];
    
}
//商品加减操作
- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([Tools boolForKey:KEY_IS_LOGIN] != YES) {
        [self noLoginView];
        
    }else{
        if (btn.tag == 1) {
            if (noLabel.text.intValue == 0) {
                [self showHUDText:@"无法再减少了"];
            }else{
                pMode = @"dec";
                [self doProductNumMethon];
            }
        }else{
            pMode = @"inc";
            [self doProductNumMethon];
        }
    }
   
}
//收藏与取消收藏方法
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

//商品数量加减方法
- (void)doProductNumMethon {
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [NSString stringWithFormat: @"%ld", (long)goodId],   @"goodId",
                         [Tools stringForKey:KEY_USER_ID],  @"userId",
                         shopId,@"shopId",
                         @"1",@"num",
                         pMode,@"mode",
                         nil];
    
    NSString *xpoint = [NSString stringWithFormat:@"/Api/Cart/edit?"];
    NSLog(@"dics:%@",dic);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        pictureUrlArray = [[NSMutableArray alloc]init];
        if ([statusMsg intValue] == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        }else if ([statusMsg intValue] == 201){
            if ([pMode isEqualToString:@"dec"]) {
                noLabel.text = [NSString stringWithFormat: @"%d",noLabel.text.intValue-1];
                
                count = [NSString stringWithFormat: @"%d",count.intValue-1];
                countLabel.text = count;
                
                
            }else if ([pMode isEqualToString:@"inc"]){
                noLabel.text = [NSString stringWithFormat: @"%d",noLabel.text.intValue+1];
                count = [NSString stringWithFormat: @"%d",count.intValue+1];
                countLabel.text = count;
            }
        }else if ([statusMsg intValue] == 4002){
            [self showHUDText:@"暂无数据"];
        }else {
            
        }
        
    } fail:^(NSError *error) {
        
    }];
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
            shopId = [[dic valueForKey:@"data"]valueForKey:@"shop_id"];
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
            cartNum = [[dic valueForKey:@"data"]valueForKey:@"cart_num"];
            cartTNum = [[dic valueForKey:@"data"]valueForKey:@"cart_t_num"];
            
            [self initUI];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

//收藏与取消收藏操作
- (void)doCollectMethod {
    if ([Tools boolForKey:KEY_IS_LOGIN] != YES) {
        [self noLoginView];
        
    }else{
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
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cartBtnClicked:(id)sender {
    //通知 发出
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refSelectedIndexByCart" object:nil];
    
    
}
-(void)noLoginView{
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    baseView.backgroundColor = [UIColor colorWithRed:191/255.0f green:193/255.0f blue:194/255.0f alpha:0.7];
    
    [self.view addSubview:baseView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30*PROPORTION, 186*PROPORTION, 260*PROPORTION, 204*PROPORTION)];
    [imageView setImage:[UIImage imageNamed:@"loginMsg"]];
    imageView.userInteractionEnabled = YES;
    [baseView addSubview: imageView];
    
    UIButton *goBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 204*PROPORTION-41*PROPORTION, 130*PROPORTION, 40)];
    goBtn.backgroundColor = [UIColor clearColor];
    goBtn.tag = 10001;
    [goBtn addTarget:self action:@selector(noLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:goBtn];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(goBtn), 204*PROPORTION-41*PROPORTION, 130*PROPORTION, 40)];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.tag = 10002;
    [loginBtn addTarget:self action:@selector(noLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:loginBtn];
}
- (IBAction)noLoginClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10001) {
        baseView.hidden = YES;
    }else if (btn.tag == 10002){
        baseView.hidden = YES;
        RegisterViewControllerNew *registeredView = [[RegisterViewControllerNew alloc]init];
        registeredView.title = @"快捷登陆";
        registeredView.hidesBottomBarWhenPushed = YES;
        registeredView.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:registeredView animated:YES];
    }
    
}
@end
