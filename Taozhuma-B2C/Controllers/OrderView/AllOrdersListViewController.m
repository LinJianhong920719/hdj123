//
//  AllOrdersListViewController.m
//  订单列表
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "AllOrdersListViewController.h"

#import "AllOrderEntity.h"
#import "AllOrderCell.h"
#import "UIImageView+WebCache.h"
//#import "ZSDPaymentView.h"
//#import "OrdersDetailsController.h"
//#import "OrderCommentViewController.h"
//#import "ZCTradeView.h"
//#import "AppPay.h"
//#import "HMTMainViewController.h"
//#import "TakeOutEntity.h"



@interface AllOrdersListViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    UIView *baseView;
//    ZSDPaymentView *payment;
    NSString *oid;
    NSString *allPrice;
    NSString *shopId;
    AllOrderEntity *allEntity;
    BOOL type;
    UIButton *btnConfirm;
    
}

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL pageType;
@end

@implementation AllOrdersListViewController

- (void)loadView {
    [super loadView];
//    self.title = @"订单";
    _pageno = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //接收通知，刷新页面
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grabSingle:) name:@"GrabSingle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPassword:) name:@"refreshPassword"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refreshByOrderDetail"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(immediatePayment:) name:@"immediatePayment"object:nil];
    
//    [Tools saveInteger:2 forKey:KEY_WX_CALLBACK];
    
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    //隐藏导航栏
    [self hideNaviBar:YES];
    //没有订单页面
    [self initDefauleUI];
    [self initTableView];
    
    [self loadData];
    [self setupHeader];

   
    
}


// ----------------------------------------------------------------------------------------
// 视图即将可见时调用
// ----------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]; // 固定调用
    
    //注册微信通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxCallback:) name:@"weixinCallback_OrderList"object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerAlertView) name:@"triggerAlertView"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refreshOrderList"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refreshOrderList_submitOrder"object:nil];
}

// ----------------------------------------------------------------------------------------
// 视图被解散后调用
// ----------------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated]; // 固定调用
    
    //撤销微信通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixinCallback_OrderList" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"triggerAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOrderList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOrderList_submitOrder" object:nil];
}

- (void)initTableView {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 33)];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 118)];
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewOrignY-viewBottom(headerView), DEVICE_SCREEN_SIZE_WIDTH,DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY-50+viewBottom(headerView)+viewBottom(footerView)) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    _mTableView.separatorInset = UIEdgeInsetsMake(0, PROPORTION414*20, 0, PROPORTION414*20);
    _mTableView.scrollIndicatorInsets = UIEdgeInsetsMake(viewBottom(headerView), 0, viewBottom(footerView), 0);
    [self.view addSubview:_mTableView];
    
    _mTableView.tableHeaderView = headerView;
    _mTableView.tableFooterView = footerView;
    
    _mTableView.hidden = YES;
    _data = [[NSMutableArray alloc]init];
    
}

// 没有订单的页面
- (void)initDefauleUI {
    
    //底层view
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT)];
    baseView.backgroundColor = BACK_DEFAULT;
    [self.view addSubview:baseView];

//    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_SCREEN_SIZE_WIDTH/4+10)*PROPORTION, heightInter, 130, 130)];
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*104)/2, PROPORTION414*150, PROPORTION414*104, PROPORTION414*104)];
    [logo setImage:[UIImage imageNamed:@"wm-107"]];
    [baseView addSubview:logo];
    
    //我的余额
    UILabel *myWallet = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(logo)+16, DEVICE_SCREEN_SIZE_WIDTH, 40)];
    myWallet.textAlignment = NSTextAlignmentCenter;
    myWallet.textColor = [UIColor colorWithRed:181/255.0f green:181/255.0f blue:182/255.0f alpha:1];
    myWallet.text = [NSString stringWithFormat:@"您现在还没有订单，赶紧点一份"];
    myWallet.font = [UIFont systemFontOfSize:16*PROPORTION414];
    [baseView addSubview:myWallet];
    
    //购物button
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake( (DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*193)/2, viewBottom(myWallet)+24, PROPORTION414*193, 36);
    [sureButton.layer setMasksToBounds:YES];
    [sureButton.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
    sureButton.backgroundColor = [UIColor colorWithRed:233/255.0f green:0/255.0f blue:154/255.0f alpha:0.8];
    [sureButton setTitle:@"现在点一份" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureButton addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];//为按钮增加时间侦听
    baseView.hidden = YES;
    [baseView addSubview:sureButton];
    
}

#pragma mark - SDRefresh

// ----------------------------------------------------------------------------------------
// 加载刷新控件 - 下拉刷新
// ----------------------------------------------------------------------------------------
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    [refreshHeader addToScrollView:_mTableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _pageno = 1;
            [self loadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

#pragma mark - 执行通知

// ----------------------------------------------------------------------------------------
// 通知 : 订单状态变更
// ----------------------------------------------------------------------------------------
- (void)grabSingle:(NSNotification*)notification {
    NSString *obj = [notification object];
    //是否是当前正在显示
    if ([Tools intForKey:KEY_TabBarNum] == 1) {
//        OrdersDetailsController *ordersDetails = [[OrdersDetailsController alloc]init];
//        ordersDetails.title = @"订单详情";
//        ordersDetails.orderID = obj;
//        ordersDetails.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:ordersDetails animated:YES];
    }
}

// ----------------------------------------------------------------------------------------
// 通知 : 刷新数据
// ----------------------------------------------------------------------------------------
- (void)refreshData:(NSNotification*)notification {
//    [_data removeAllObjects];
//    [_mTableView reloadData];
    _pageno = 1;
    [self loadData];
    
}

// ----------------------------------------------------------------------------------------
// 通知 : 用户付款成功
// ----------------------------------------------------------------------------------------
- (void)refreshPassword:(NSNotification*) notification {
    
//    NSString *passWord = [NSString stringWithFormat:@"%@",[notification object]];
//    
//    //支付接口
//    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
//                          @"paid",                         @"act",
//                          @"e3dc653e2d68697346818dfc0b208322",       @"key",
//                          [Tools stringForKey:KEY_USER_ID],     @"uid",
//                          oid,                      @"oid",
//                          allPrice,                 @"paymoney",
//                          @"1",                     @"pay_method",
//                          [self md5:passWord],      @"pay_pass",
//                          shopId,                   @"sid",
//                          nil];
//    NSLog(@"dic:%@", dics);
//    NSString *xpoint = ORDERXPOINT;
//    [MailWorldRequest requestWithParams:dics xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//        } else {
//            
//            NSLog(@"%@",respond.error_msg);
//
//            if (respond.result  == 1) {
//                UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:respond.title message:respond.content delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                alerts.tag = 10010;
//                [alerts show];
//                [self performSelector:@selector(refreshData:) withObject:nil afterDelay:1.0];
//                [self performSelector: @selector(submitSuccessFunction) withObject: self afterDelay: 2];
//            } else {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.detailsLabelText = respond.error_msg;
//                hud.yOffset = -50.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//            }
//            [payment dismiss];
//        }
//    }];
}


// ----------------------------------------------------------------------------------------
// 微信支付回调通知
// ----------------------------------------------------------------------------------------
- (void)wxCallback:(NSNotification*)notification {
    
    NSArray *obj = [notification object];
    
    NSString *resultStr = [obj objectAtIndex:0];
    NSInteger result = [resultStr integerValue];
    NSString *strTitle = [obj objectAtIndex:1];
    NSString *memo = [obj objectAtIndex:2];
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:strTitle message:memo delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alter.tag = result;
    [alter show];
    
}


#pragma mark - 加载数据

// ----------------------------------------------------------------------------------------
// 获取订单列表数据
// ----------------------------------------------------------------------------------------
- (void)loadData {
    
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         [NSNumber numberWithInteger:_pageno],        @"page",
//                         @"e3dc653e2d68697346818dfc0b208322",     @"key",
//                         [Tools stringForKey:KEY_USER_ID],        @"uid",
//                         @"get_list",                           @"act",
//                         @"0",                           @"status",
//                         nil];
//    NSString *xpoint = ORDERXPOINT;
//    
//    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//            
//        } else {
//            
//            
//            if (_pageno == 1) {
//                [_data removeAllObjects];
//            }
//            
//            if ([respond.respondArray count] > 0) {
//                _pageType = YES;
//                
//                baseView.hidden = YES;
//                _mTableView.hidden = NO;
//                
//                for (NSDictionary *temList in respond.respondArray) {
//                    AllOrderEntity *entity = [[AllOrderEntity alloc]initWithAttributes:temList];
//                    [_data addObject:entity];
//                }
//                
//                
//            } else {
//                _pageType = NO;
//                
//                if (_data.count == 0) {
//                    _mTableView.hidden = YES;
//                    baseView.hidden = NO;
//                }
//            }
//            [_mTableView reloadData];
// 
//        }
//        
//    }];
}
-(void)triggerAlertView{
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户完成付款后才算订单完成!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      alter.tag = 10086;
    [alter show];

}
#pragma mark - UIScrollViewDelegate

// ----------------------------------------------------------------------------------------
// 开始拖动时通知
// ----------------------------------------------------------------------------------------
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self.view bringSubviewToFront:self.navigationBar];
}

#pragma mark - UITableViewDataSource

// ----------------------------------------------------------------------------------------
// 获取当前cell的位置
// ----------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%lu:%ld",(unsigned long)_data.count,(long)[indexPath section]);
//    if (_data.count - [indexPath section] < 5 && _pageType) {
//        [self upDate];
//    }
}

// ----------------------------------------------------------------------------------------
// 加载下一页数据
// ----------------------------------------------------------------------------------------
- (void)upDate {
    _pageType = NO;
    _pageno ++;
    [self loadData];
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
// 设置 cell 行高
// ----------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

// ----------------------------------------------------------------------------------------
// numberOfSectionsInTableView:(UITableView *)tableView
// 设置分区数量
// ----------------------------------------------------------------------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
//    return [_data count];
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
// 设置每个分区的 cell 行数
// ----------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    AllOrderEntity *entity = [_data objectAtIndex:section];
    //获取分组里面的数组
    return 2;
//    return [entity._carts count];
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
// 设置 cell 展示内容
// ----------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AllOrderCell";
    AllOrderCell *cell = (AllOrderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllOrderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    if ([_data count] > 0) {
//        
//        AllOrderEntity *entity = [_data objectAtIndex:[indexPath section]];
//        NSArray *carts = [entity._carts objectAtIndex:[indexPath row]];
        [cell.shopImage setFrame:CGRectMake(PROPORTION414*20, 7, 60, 61)];
//
//        if ([self isBlankString:[carts valueForKey:@"product_img"]]) {
//            cell.shopImage.image = [UIImage imageNamed:@"wm-default100"];
//        } else {
//            [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:[carts valueForKey:@"product_img"]] placeholderImage:[UIImage imageNamed:@"wm-default100"]];
//        }
//        
        cell.shopImage.layer.borderWidth = 0.5;
        cell.shopImage.layer.borderColor = [LINECOLOR_DEFAULT CGColor];
        
        cell.shopName.numberOfLines = 2;
//        cell.shopName.text = [carts valueForKey:@"product_name"];
        cell.shopName.textColor = UIColorWithRGBA(102, 100, 100, 1);
        CGSize size = [cell.shopName.text sizeWithFont: cell.shopName.font constrainedToSize:CGSizeMake( 170, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [cell.shopName setFrame:CGRectMake( viewRight(cell.shopImage)+10, 12, 170, size.height+1)];
//
        [cell.shopPrice setFrame:CGRectMake( DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+61), 12, 61, 20)];
        cell.shopPrice.textColor = UIColorWithRGBA(63, 58, 57, 1);
        cell.shopPrice.font = [UIFont systemFontOfSize:13];
//        cell.shopPrice.text = [NSString stringWithFormat:@"¥ %0.2f",[[carts valueForKey:@"product_price"] floatValue]];
        cell.shopPrice.textAlignment = NSTextAlignmentRight;
//
        [cell.shopNum setFrame:CGRectMake( DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+61), 32, 61, 18 )];
        cell.shopNum.textColor = UIColorWithRGBA(181, 181, 182, 1);
        cell.shopNum.font = [UIFont systemFontOfSize:10];
//        cell.shopNum.text = [NSString stringWithFormat:@"x%@",[carts valueForKey:@"nums"]];
        cell.shopNum.textAlignment = NSTextAlignmentRight;
//    }
    return cell;
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
// 设置 cell 点击执行
// ----------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    AllOrderEntity *entity = [_data objectAtIndex:[indexPath section]];
//    OrdersDetailsController *ordersDetails = [[OrdersDetailsController alloc]init];
//    ordersDetails.title = @"订单详情";
//    ordersDetails.hidesBottomBarWhenPushed = YES;
//    ordersDetails.orderID =  entity.oid;
//    ordersDetails.navigationController.navigationBarHidden = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyTrade" object:nil];
//    [self.navigationController pushViewController:ordersDetails animated:YES];
    
}

#pragma mark UITableView cellHeaderView / cellFooterView

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
// 设置分区 Header 高度
// ----------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33;
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
// 设置分区 Footer 高度
// ----------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 118;
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
// 设置分区 Header 展示内容
// ----------------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    //分割线
    EMAsyncImageView *line1 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, 0,DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [line1 setBackgroundColor:UIColorWithRGBA(238, 239, 239, 1)];
    [view addSubview:line1];
    EMAsyncImageView *line2 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, 31,DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [line2 setBackgroundColor:UIColorWithRGBA(238, 239, 239, 1)];
    [view addSubview:line2];
    
    NSString *orderStatus = @"1";
        NSString *orderIsCancel = @"1";
        NSString *orderIsRefuse = @"1";
//    AllOrderEntity *entity = [_data objectAtIndex:section];
//    NSString *orderStatus = entity.orderStatus;
//    NSString *orderIsCancel = entity.isCancel;
//    NSString *orderIsRefuse = entity.isRefuse;
    
    //店铺模块
    EMAsyncImageView *shopLogo = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(PROPORTION414*20, 7, 16, 16)];
    shopLogo.image = [UIImage imageNamed:@"store"];
    [view addSubview:shopLogo];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PROPORTION414*30+17, 0, 81, 32)];
    label.textColor = UIColorWithRGBA(137, 137, 137, 1);
    label.font = [UIFont boldSystemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
//    label.text = [NSString stringWithFormat:@"%@",entity.shopName];
    [view addSubview:label];
    
    UILabel *state = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+61), 0, 61, 32)];
    state.textColor = PRODUCT_COLOR;
    state.font = [UIFont boldSystemFontOfSize:11];
    state.backgroundColor = [UIColor clearColor];
//    if([orderStatus isEqualToString:@"待支付"]&&[orderIsCancel isEqualToString:@"0"]){
//        state.text = @"尚未付款";
//    }else if([orderStatus isEqualToString:@"待支付"]&&[orderIsCancel isEqualToString:@"1"]){
//        state.text = @"交易关闭";
//    }else if([orderStatus isEqualToString:@"待发货"]&&[orderIsRefuse isEqualToString:@"0"]){
//        state.text = @"等待配送";
//    }else if([orderStatus isEqualToString:@"待发货"]&&[orderIsRefuse isEqualToString:@"2"]){
//        state.text = @"等待接收";
//    }else if([orderStatus isEqualToString:@"待发货"]&&[orderIsRefuse isEqualToString:@"1"]){
//        state.text = @"交易关闭";
//    }else if ([orderStatus isEqualToString:@"待收货"]){
//        state.text = @"卖家已配送";
//    }else {
//        state.text = @"交易成功";
//    }
    state.textAlignment = NSTextAlignmentRight;
    [view addSubview:state];
    
    CGSize nickNameSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 32)];
    [label setFrame:CGRectMake(PROPORTION414*30+17, 0, nickNameSize.width, 32)];
    
    //箭头图标
    EMAsyncImageView *arrowLogo = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(viewRight(label)+PROPORTION414*10, 12, 8, 9)];
    arrowLogo.image = [UIImage imageNamed:@"wm-019"];
    [view addSubview:arrowLogo];
    
    //进入店铺详情按钮
    UIButton *shopBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 32)];
    shopBtn.tag = section;
    [shopBtn addTarget:self action:@selector(btnShopClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shopBtn];
    
    return view;
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
// 设置分区 Footer 展示内容
// ----------------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    AllOrderEntity *entity = [_data objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 103)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    //分割线
    EMAsyncImageView *line1 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(PROPORTION414*10, 0, DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*30, 1)];
    [line1 setBackgroundColor:BACK_DEFAULT];
    [view addSubview:line1];
    EMAsyncImageView *line2 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(PROPORTION414*10, 58, DEVICE_SCREEN_SIZE_WIDTH-30, 1)];
    [line2 setBackgroundColor:BACK_DEFAULT];
    [view addSubview:line2];
    EMAsyncImageView *line3 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, 107, DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [line3 setBackgroundColor:LINECOLOR_DEFAULT];
    [view addSubview:line3];
    
    //订单总额模块
    UILabel *freight = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+65), 22, 65, 42)];
    freight.font = [UIFont systemFontOfSize:13];
    freight.textColor = UIColorWithRGBA(63, 58, 57, 1);
//    freight.text =[NSString stringWithFormat:@"¥ %0.2f",[entity.allPrice floatValue]];
    freight.textAlignment = NSTextAlignmentRight;
    [view addSubview:freight];
    
    CGSize nickNameSize = [freight.text sizeWithFont:freight.font constrainedToSize:CGSizeMake(MAXFLOAT, 42)];
    [freight setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+nickNameSize.width), 22, nickNameSize.width, 42)];
    
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(freight.frame.origin.x-35-PROPORTION414*8,22, 35, 42)];
    freightLabel.font = [UIFont systemFontOfSize:13];
    freightLabel.textColor = UIColorWithRGBA(181, 181, 182, 1);
    freightLabel.text =@"实付:";
    freightLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:freightLabel];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+65), 0, 65, 42)];
    price.font = [UIFont systemFontOfSize:13];
    price.textColor = UIColorWithRGBA(63, 58, 57, 1);
//    price.text =[NSString stringWithFormat:@"¥ %@",entity.freight];
    price.textAlignment = NSTextAlignmentRight;
    [view addSubview:price];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(price.frame.origin.x-10-PROPORTION414*8, 0, 35, 42)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorWithRGBA(181, 181, 182, 1);
    label.text =@"运费:";
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    
    UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(freightLabel.frame.origin.x-PROPORTION414*13-70, 22, 70, 42)];
    num.font = [UIFont systemFontOfSize:13];
    num.textColor = FONTS_COLOR;
//    num.text =[NSString stringWithFormat:@"共%@件产品",entity.num];
    num.textAlignment = NSTextAlignmentRight;
    [view addSubview:num];
    
    CGSize numNameSize = [num.text sizeWithFont:num.font constrainedToSize:CGSizeMake(MAXFLOAT, 42)];
    [num setFrame:CGRectMake(freightLabel.frame.origin.x-PROPORTION414*13-numNameSize.width, 22, numNameSize.width, 42)];
    
    //付款收货评价按钮模块
     btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnConfirm setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-67, 71, 67, 25)];
//    btnConfirm.tag = [entity.oid integerValue];
//    if ([entity.orderStatus isEqualToString:@"待支付"]&& [entity.isCancel intValue] ==0) {
//    
//        
//        [btnConfirm setTitle:@"立即付款" forState:UIControlStateNormal];
//        [btnConfirm setTitleColor:PRODUCT_COLOR forState:UIControlStateNormal];
//        btnConfirm.layer.borderColor = [PRODUCT_COLOR CGColor];
//        btnConfirm.tag = section;
//        [btnConfirm addTarget:self action:@selector(immediatePayment:) forControlEvents:UIControlEventTouchUpInside];
    

//        UIActionSheet *paySheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"钱包支付" otherButtonTitles:@"支付宝支付", @"微信支付", nil];
//        paySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
     
//    }else if ([entity.orderStatus isEqualToString:@"待支付"] && [entity.isCancel intValue] ==1 ) {
//        
//        [btnConfirm setTitle:@"交易取消" forState:UIControlStateNormal];
//        [btnConfirm setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
//        btnConfirm.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
//        
//        btnConfirm.tag = section;
//        
//    } else if ([entity.orderStatus isEqualToString:@"待发货"]&& [entity.isRefuse intValue] == 0) {
//        
//        [btnConfirm setTitle:@"待配送" forState:UIControlStateNormal];
//        [btnConfirm setTitleColor:PRODUCT_COLOR forState:UIControlStateNormal];
//        btnConfirm.layer.borderColor = [PRODUCT_COLOR CGColor];
//        
//    }else if ([entity.orderStatus isEqualToString:@"待发货"]&& [entity.isRefuse intValue] == 2) {
//        
//        [btnConfirm setTitle:@"待确认" forState:UIControlStateNormal];
//        [btnConfirm setTitleColor:PRODUCT_COLOR forState:UIControlStateNormal];
//        btnConfirm.layer.borderColor = [PRODUCT_COLOR CGColor];
//        
//    }else if ([entity.orderStatus isEqualToString:@"待发货"]&& [entity.isRefuse intValue] ==1) {
//        
//        [btnConfirm setTitle:@"已拒绝" forState:UIControlStateNormal];
//        [btnConfirm setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
//        btnConfirm.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
//        
//    } else if ([entity.orderStatus isEqualToString:@"待收货"]) {
//        
//        [btnConfirm setTitle:@"到达确认" forState:UIControlStateNormal];
//        [btnConfirm setTitleColor:PRODUCT_COLOR forState:UIControlStateNormal];
//        btnConfirm.layer.borderColor = [PRODUCT_COLOR CGColor];
//        [btnConfirm addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//    } else if ([entity.orderStatus isEqualToString:@"交易成功"]) {
//        
//        if([entity.isDiscuss integerValue] == 0){
//            btnConfirm.hidden =NO;
//            [btnConfirm setTitle:@"评论" forState:UIControlStateNormal];
//            [btnConfirm setTitleColor:PRODUCT_COLOR forState:UIControlStateNormal];
//            btnConfirm.layer.borderColor = [PRODUCT_COLOR CGColor];
//            [btnConfirm addTarget:self action:@selector(btnCommentsClick:) forControlEvents:UIControlEventTouchUpInside];
//            
//        }
//        else {
//            
//            [btnConfirm setTitle:@"已评论" forState:UIControlStateNormal];
//            [btnConfirm setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
//            btnConfirm.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
//        }
//        
//    }
//    
//    
//    btnConfirm.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//    btnConfirm.layer.borderWidth = 0.5;
//    btnConfirm.layer.cornerRadius = 3;
//    [view addSubview:btnConfirm];
    
    //取消订单模块
    
//    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    if ([entity.orderStatus isEqualToString:@"待支付"]&& [entity.isCancel intValue] ==0)  {
//        
//        [btnCancel setTitle:@"取消订单" forState:UIControlStateNormal];
//        [btnCancel setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-142, 71, 67, 25)];
//        [btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
//    } else if ([entity.orderStatus isEqualToString:@"待发货"]&& [entity.isRefuse intValue] !=1) {
//        
//        btnCancel.hidden = YES;
//    } else if ([entity.orderStatus isEqualToString:@"待收货"]) {
//        
//        btnCancel.hidden = YES;
//        
//    } else {
//        
//        [btnCancel setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-142, 71, 67, 25)];
//        [btnCancel setTitle:@"删除订单" forState:UIControlStateNormal];
//        [btnCancel addTarget:self action:@selector(btndelClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    btnCancel.tag = [entity.oid integerValue];
//    
//    [btnCancel setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
//    btnCancel.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
//    btnCancel.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//    btnCancel.layer.borderWidth = 0.5;
//    btnCancel.layer.cornerRadius = 3;
//    [view addSubview:btnCancel];
    
    //底部灰色模块
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, DEVICE_SCREEN_SIZE_WIDTH, 10)];
    [bgView setBackgroundColor:BACK_DEFAULT];
    [view addSubview:bgView];
    
    return view;
}

#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 3) {
        return;
    }
    
    if (buttonIndex == 0) {
        [self chooseWallet];
    } else {
        NSString *payType = [NSString stringWithFormat:@"%ld",(long)buttonIndex + 1];
        [self performPay:payType];
    }
    
}

#pragma mark -

- (void)performPay:(NSString *)payMethod {
    //支付接口
//    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
//                          @"paid",                                          @"act",
//                          @"e3dc653e2d68697346818dfc0b208322",            @"key",
//                          [Tools stringForKey:KEY_USER_ID],               @"uid",
//                          oid,                                              @"oid",
//                          allPrice,                                         @"paymoney",
//                          payMethod,                                          @"pay_method",
//                          @"",                                              @"pay_pass",
//                          shopId,                                           @"sid",
//                          nil];
//    NSLog(@"dic:%@", dics);
//    NSString *xpoint = ORDERXPOINT;
//    [MailWorldRequest requestWithParams:dics xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//        } else {
//            
//            if (respond.result == 1) {
//                
//                NSDictionary *aplipay = respond.respondData ;
//                NSDictionary *wxpay = respond.respondData ;
//                
//                AppPay *pay = [AppPay alloc];
//                if ([payMethod isEqual:@"2"]) {
//                    //支付宝支付
//                    [pay initWithDicctionary:aplipay fromPay:@"Alpay" payDelegate:self];
//                }
//                
//                if([payMethod isEqual:@"3"]) {
//                    //微信支付
//                    [pay initWithDicctionary:wxpay fromPay:@"Wxpay" payDelegate:self];
//                }
//                
//            } else {
//                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示信息" message:respond.error_msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [alter show];
//            }
//        }
//    }];
}



// ----------------------------------------------------------------------------------------
// 支付宝 支付回调
// ----------------------------------------------------------------------------------------
- (void)callbackResult:(NSInteger)result resultTitle:(NSString *)title errorContent:(NSString *)error {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:error delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alter.tag = result;
    [alter show];
}

// ----------------------------------------------------------------------------------------
// 立即付款
// ----------------------------------------------------------------------------------------
- (void)immediatePayment:(id)sender {
    UIButton *btn = (UIButton *)sender;
     NSLog(@"%@",btn);

    allEntity = [_data objectAtIndex:btn.tag];
    oid = allEntity.oid;
    allPrice = allEntity.allPrice;
    shopId = allEntity.shopId;
    
    UIActionSheet *paySheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"钱包支付" otherButtonTitles:@"支付宝支付", @"微信支付", nil];
    paySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;

    [paySheet showInView:self.view];

    
}

// ----------------------------------------------------------------------------------------
// 跳转 - 订单详情
// ----------------------------------------------------------------------------------------
- (void)submitSuccessFunction {
//    OrdersDetailsController *ordersDetailsView = [[OrdersDetailsController alloc]init];
//    ordersDetailsView.title = @"订单";
//    ordersDetailsView.orderID = oid;
//    ordersDetailsView.hidesBottomBarWhenPushed = YES;
//    ordersDetailsView.navigationController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:ordersDetailsView animated:YES];
}

// ----------------------------------------------------------------------------------------
// 取消订单
// ----------------------------------------------------------------------------------------
- (IBAction)btnCancelClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    oid = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定取消订单？"message:@"取消之后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag=110;
    [alert show];
}

// ----------------------------------------------------------------------------------------
// 确认收货
// ----------------------------------------------------------------------------------------
- (IBAction)btnConfirmClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         @"edit",@"act",
//                         @"e3dc653e2d68697346818dfc0b208322",@"key",
//                         [NSString stringWithFormat:@"%ld",(long)btn.tag],           @"oid",
//                         [Tools stringForKey:KEY_USER_ID],        @"uid",
//                         @"3",                                  @"status",
//                         nil];
//    NSLog(@"dic:%@",dic);
//    NSString *xpoint = ORDERXPOINT;
//    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//        } else {
//            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//            
//            if (respond.result == 1) {
//                hud.detailsLabelText = @"收货成功";
//                [self performSelector:@selector(refreshData:) withObject:nil afterDelay:2.0];
//            } else {
//                hud.detailsLabelText = @"操作失败,请重试";
//            }
//            
//        }
//    }];
    
}

// ----------------------------------------------------------------------------------------
// 订单评价
// ----------------------------------------------------------------------------------------
- (IBAction)btnCommentsClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    
//    OrderCommentViewController * CommentslView = [[OrderCommentViewController alloc]init];
//    CommentslView.oid = [NSString stringWithFormat:@"%ld",(long)btn.tag];
//    CommentslView.title = @"订单评价";
//    CommentslView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:CommentslView animated:YES];
}

// ----------------------------------------------------------------------------------------
// 返回首页
// ----------------------------------------------------------------------------------------
- (IBAction)sureClick:(id)sender {
//    [[AppDelegate sharedAppDelegate]loadMainView];
    
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    [[AppDelegate sharedAppDelegate].mainTabBarController setSelectedIndex:0];
}

// ----------------------------------------------------------------------------------------
// 进入店铺
// ----------------------------------------------------------------------------------------
- (IBAction)btnShopClick:(id)sender {

    UIButton *btn = (UIButton *)sender;
   
//    allEntity = [_data objectAtIndex:btn.tag];
//    
//    HMTMainViewController * disheView = [[HMTMainViewController alloc]init];
//    disheView.shopID = allEntity.shopId;
//    
//    disheView.sendPrice = [allEntity.sendPrice floatValue];
//    NSLog(@"%f",[allEntity.sendPrice floatValue]);
//    disheView.title = allEntity.shopName;
//    disheView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:disheView animated:YES];
//    
//    [self.navigationController setToolbarHidden:YES animated:YES];

    
}

// ----------------------------------------------------------------------------------------
// 钱包支付
// ----------------------------------------------------------------------------------------
- (void)chooseWallet {
    
//    //判断钱包是否有密码
//    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
//                          @"check",                         @"act",
//                          @"e3dc653e2d68697346818dfc0b208322",       @"key",
//                          [Tools stringForKey:KEY_USER_ID],@"uid",
//                          nil];
//    NSLog(@"dic:%@", dics);
//    NSString *xpoint = WALLETXPOINT;
//    [MailWorldRequest requestWithParams:dics xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//        } else {
//            if ([[respond.respondData valueForKey:@"wallet_pwd"] integerValue]  == 1) {
//                
//                [self performSelector: @selector(payPassword) withObject:self afterDelay:0.5];
//                
//            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未设置钱包密码"message:@"请点击“我的钱包”设置钱包密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//                alert.tag=130;
//                [alert show];
//            }
//        }
//    }];
}

- (void)payPassword {
//    payment = [[ZSDPaymentView alloc]init];
//    payment.title = @"支付密码";
//    payment.goodsName = @"支付金额";
//    payment.amount = [allPrice floatValue];
//    payment.type = 2;
//    [payment show];
}

// ----------------------------------------------------------------------------------------
// 删除订单
// ----------------------------------------------------------------------------------------
- (IBAction)btndelClick:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    oid = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除订单？"message:@"删除之后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag=120;
    [alert show];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 0) {
//        [_data removeAllObjects];
//        [_mTableView reloadData];
        _pageno = 1;
        [self loadData];
    }
 
    
    if (alertView.tag == 110) {
        
        if (buttonIndex == 1) {
//            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                                 oid,           @"oid",
//                                 @"cancel",@"act",
//                                 @"e3dc653e2d68697346818dfc0b208322",@"key",
//                                 [Tools stringForKey:KEY_USER_ID],@"uid",
//                                 nil];
//            NSString *xpoint = ORDERXPOINT;
//            [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//                if (error) {
//                } else {
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.detailsLabelText = respond.error_msg;
//                    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
//                    hud.removeFromSuperViewOnHide = YES;
//                    [hud hide:YES afterDelay:1];
//                    [self performSelector:@selector(refreshData:) withObject:nil afterDelay:1.0];
//                }
//            }];
        }
    }
    
    if (alertView.tag == 120) {
        if (buttonIndex == 1) {
//            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                                 oid,           @"oid",
//                                 @"del",@"act",
//                                 @"e3dc653e2d68697346818dfc0b208322",@"key",
//                                 [Tools stringForKey:KEY_USER_ID],@"uid",
//                                 nil];
//            NSString *xpoint = ORDERXPOINT;
//            [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//                if (error) {
//                } else {
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.detailsLabelText = respond.error_msg;
//                    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
//                    hud.removeFromSuperViewOnHide = YES;
//                    [hud hide:YES afterDelay:1];
//                    [self performSelector:@selector(refreshData:) withObject:nil afterDelay:1.0];
//                }
//            }];
        }
    }
    
    if (alertView.tag == 130) {
    }
}
//AlertView已经消失时执行的事件
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 10086){
//        
//        [self performSelector:@selector(immediatePayment:) withObject:nil afterDelay:0.5];
//        
//    }
//    if (alertView.tag == 10010) {
//        _pageno = 1;
//        [self loadData];
//    }
//
//
//}



#pragma mark -

// ----------------------------------------------------------------------------------------
// 视图控制器接收内存警告消息时执行
// ----------------------------------------------------------------------------------------
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}




@end