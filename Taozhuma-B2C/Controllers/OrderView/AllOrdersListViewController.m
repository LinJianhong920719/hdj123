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
#import "OrdersDetailsController.h"
#import "CommentOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "PaySuccessViewController.h"
#import "PayFailViewController.h"



@interface AllOrdersListViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    UIView *baseView;
//    ZSDPaymentView *payment;
    NSString *oid;
    NSString *allPrice;
    NSString *shopId;
    AllOrderEntity *allEntity;
    BOOL type;
    UIButton *btnConfirm;
    int pager;
    
}

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) NSInteger pageno;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL pageType;
@end

@implementation AllOrdersListViewController

- (void)loadView {
    [super loadView];
    _pageno = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pager = 1;
    //接收通知，刷新页面
   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grabSingle:) name:@"GrabSingle" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPassword:) name:@"refreshPassword"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refreshByOrderDetail"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(immediatePayment:) name:@"immediatePayment"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessMethod:) name:@"alipaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailMethod:) name:@"alipayFail" object:nil];
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
    [self setupFooter];

   
    
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
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH,DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY-40) style:UITableViewStyleGrouped];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
//    _mTableView.separatorInset = UIEdgeInsetsMake(0, PROPORTION414*20, 0, PROPORTION414*20);
//    _mTableView.scrollIndicatorInsets = UIEdgeInsetsMake(viewBottom(headerView), 0, viewBottom(footerView), 0);
    [self.view addSubview:_mTableView];
    
    _mTableView.tableHeaderView = headerView;
    _mTableView.tableFooterView = footerView;
    
//    _mTableView.hidden = YES;
    _data = [[NSMutableArray alloc]init];
    
}

// 没有订单的页面
- (void)initDefauleUI {
    
    //底层view
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT)];
    baseView.backgroundColor = BGCOLOR_DEFAULT;
    [self.view addSubview:baseView];

//    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_SCREEN_SIZE_WIDTH/4+10)*PROPORTION, heightInter, 130, 130)];
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake((DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*104)/2, PROPORTION414*150, PROPORTION414*104, PROPORTION414*104)];
    [logo setImage:[UIImage imageNamed:@"order_null"]];
    [baseView addSubview:logo];
    
    //我的余额
    UILabel *myWallet = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(logo)+16, DEVICE_SCREEN_SIZE_WIDTH, 40)];
    myWallet.textAlignment = NSTextAlignmentCenter;
    myWallet.textColor = [UIColor colorWithRed:181/255.0f green:181/255.0f blue:182/255.0f alpha:1];
    myWallet.text = [NSString stringWithFormat:@"暂无订单"];
    myWallet.font = [UIFont systemFontOfSize:16*PROPORTION414];
    [baseView addSubview:myWallet];
    

    baseView.hidden = YES;

    
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
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_mTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           pager ++;
           [self loadData];
        [self.refreshFooter endRefreshing];
    });
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
    [_data removeAllObjects];
    [_mTableView reloadData];
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
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         @"0",@"type",
                         [NSString stringWithFormat:@"%d",pager],@"pager",
                         nil];
    NSString *path = [NSString stringWithFormat:@"/Api/Order/showList?"];
    NSLog(@"dic:%@",dic);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }else if ([statusMsg intValue] == 201){
            //获取成功，无数据情况
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"无数据!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }else{
            NSArray *orderData = [dic valueForKey:@"data"];
//            NSLog(@"orderData:%@",orderData);
            for (NSDictionary *dic in orderData) {
                AllOrderEntity *allOrderEntity = [[AllOrderEntity alloc]initWithAttributes:dic];
                [_data addObject:allOrderEntity];
                [_mTableView reloadData];
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
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
    AllOrderCell *cell = (AllOrderCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

// ----------------------------------------------------------------------------------------
// numberOfSectionsInTableView:(UITableView *)tableView
// 设置分区数量
// ----------------------------------------------------------------------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 10;
    return [_data count];
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
// 设置每个分区的 cell 行数
// ----------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AllOrderEntity *entity = [_data objectAtIndex:section];
    //获取分组里面的数组
//    return 2;
    return [entity._carts count];
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
    
    if ([_data count] > 0) {

        AllOrderEntity *entity = [_data objectAtIndex:[indexPath section]];
        NSArray *carts = [entity._carts objectAtIndex:[indexPath row]];

        if ([self isBlankString:[carts valueForKey:@"good_image"]]) {
            cell.shopImage.image = [UIImage imageNamed:@"暂无图片"];
        } else {
            [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:[carts valueForKey:@"good_image"]] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        }
        cell.shopImage.layer.borderWidth = 0.5;
        cell.shopImage.layer.borderColor = [LINECOLOR_DEFAULT CGColor];
        
        cell.shopName.numberOfLines = 2;
        cell.shopName.text = [carts valueForKey:@"good_name"];
        cell.shopName.textColor = UIColorWithRGBA(102, 100, 100, 1);

        cell.shopPrice.text = [NSString stringWithFormat:@"¥ %0.2f",[[carts valueForKey:@"good_price"] floatValue]];
        cell.shopPrice.textAlignment = NSTextAlignmentLeft;

        cell.shopNum.text = [NSString stringWithFormat:@"x%@",[carts valueForKey:@"nums"]];
        cell.shopNum.textAlignment = NSTextAlignmentRight;
    }
    return cell;
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
// 设置 cell 点击执行
// ----------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllOrderEntity *entity = [_data objectAtIndex:[indexPath section]];
    OrdersDetailsController *ordersDetails = [[OrdersDetailsController alloc]init];
    ordersDetails.title = @"订单详情";
    ordersDetails.orderId = entity.oid;
    ordersDetails.shopId = entity.shopId;
    [self.navigationController pushViewController:ordersDetails animated:YES];
    
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
// 去掉UItableview headerview黏性(sticky)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat sectionHeaderHeight = 33;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//    
//    
//}
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
//    EMAsyncImageView *line2 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, 31,DEVICE_SCREEN_SIZE_WIDTH, 1)];
//    [line2 setBackgroundColor:UIColorWithRGBA(238, 239, 239, 1)];
//    [view addSubview:line2];
    

    AllOrderEntity *entity = [_data objectAtIndex:section];
    NSString *orderStatus = entity.orderStatus;//支付状态
    NSString *orderIsCancel = entity.isCancel;//是否取消
    NSString *orderIsRefuse = entity.isRefuse;//是否拒绝
    NSString *orderShippingStatus = entity.shipping_status;//配送状态
    NSString *orderIsDiscuss = entity.isDiscuss;//是否评论
    NSString *orderIsDel = entity.isDelete;//是否删除
    
    //店铺模块
    EMAsyncImageView *shopLogo = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(PROPORTION414*20, 7, 16, 16)];
    
    if ([self isBlankString:entity.shopLogo]) {
        shopLogo.image = [UIImage imageNamed:@"store"];
    } else {

        NSString *images = entity.shopLogo;
        [shopLogo sd_setImageWithURL:[NSURL URLWithString:images] placeholderImage:[UIImage imageNamed:@"store"]];
    }
    [view addSubview:shopLogo];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PROPORTION414*30+17, 0, 81, 32)];
    label.textColor = UIColorWithRGBA(102, 102, 102, 1);
    label.font = [UIFont boldSystemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%@",entity.shopName];
    [view addSubview:label];
    
    UILabel *state = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+61), 0, 61, 32)];
    state.textColor = RGB(255, 80, 0);
    state.font = [UIFont boldSystemFontOfSize:11];
    state.backgroundColor = [UIColor clearColor];
    if([orderStatus intValue] == 0 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        state.text = @"等待付款";
    }else if([orderStatus intValue] == 0 && [orderIsCancel intValue] == 1 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        state.text = @"交易失败";
    }else if([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        state.text = @"等待配送";
    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 1 && [orderIsDel intValue] == 0){
        state.text = @"正在配送";
    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 1 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        state.text = @"交易失败";
    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 2 && [orderIsDel intValue] == 0){
        state.text = @"交易成功";
    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 1 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 2 && [orderIsDel intValue] == 0){
        state.text = @"交易成功";
    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsRefuse intValue] == 1 && [orderShippingStatus intValue] == 3 && [orderIsDel intValue] == 0){
        state.text = @"交易失败";
    }
    state.textAlignment = NSTextAlignmentRight;
    [view addSubview:state];
    
    CGSize nickNameSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 32)];
    [label setFrame:CGRectMake(PROPORTION414*30+17, 0, nickNameSize.width, 32)];
    
    //箭头图标
    EMAsyncImageView *arrowLogo = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(viewRight(label)+PROPORTION414*10, 12, 8, 9)];
    arrowLogo.image = [UIImage imageNamed:@"address_go"];
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
    AllOrderEntity *entity = [_data objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 103)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    //分割线
//    EMAsyncImageView *line1 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(PROPORTION414*10, 0, DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*30, 1)];
//    [line1 setBackgroundColor:LINECOLOR_DEFAULT];
//    [view addSubview:line1];
    EMAsyncImageView *line2 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(PROPORTION414*10, 58, DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [line2 setBackgroundColor:LINECOLOR_DEFAULT];
    [view addSubview:line2];
    EMAsyncImageView *line3 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, 107, DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [line3 setBackgroundColor:LINECOLOR_DEFAULT];
    [view addSubview:line3];
    
    //订单总额模块
    UILabel *freight = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+65), 22, 65, 42)];
    freight.font = [UIFont systemFontOfSize:12];
    freight.textColor = UIColorWithRGBA(255, 80, 0, 1);
    freight.text =[NSString stringWithFormat:@"¥ %0.2f",[entity.allPrice floatValue]];
    freight.textAlignment = NSTextAlignmentRight;
    [view addSubview:freight];
    
    CGSize nickNameSize = [freight.text sizeWithFont:freight.font constrainedToSize:CGSizeMake(MAXFLOAT, 42)];
    [freight setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+nickNameSize.width), 22, nickNameSize.width, 42)];
    
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(freight.frame.origin.x-35-PROPORTION414*8,22, 35, 42)];
    freightLabel.font = [UIFont systemFontOfSize:12];
    freightLabel.textColor = UIColorWithRGBA(102, 102, 102, 1);
    freightLabel.text =@"合计:";
    freightLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:freightLabel];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-(PROPORTION414*20+65), 0, 65, 42)];
    price.font = [UIFont systemFontOfSize:12];
    price.textColor = UIColorWithRGBA(102, 102, 102, 1);
    price.text =[NSString stringWithFormat:@"¥ %@",entity.freight];
    price.textAlignment = NSTextAlignmentRight;
    [view addSubview:price];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(price.frame.origin.x-15-PROPORTION414*8, 0, 45, 42)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColorWithRGBA(102, 102, 102, 1);
    label.text =@"配送费:";
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    
    UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(freightLabel.frame.origin.x-PROPORTION414*13-70, 22, 70, 42)];
    num.font = [UIFont systemFontOfSize:12];
    num.textColor = UIColorWithRGBA(102, 102, 102, 1);;
    num.text =[NSString stringWithFormat:@"共%@件产品",entity.num];
    num.textAlignment = NSTextAlignmentRight;
    [view addSubview:num];
    
    CGSize numNameSize = [num.text sizeWithFont:num.font constrainedToSize:CGSizeMake(MAXFLOAT, 42)];
    [num setFrame:CGRectMake(freightLabel.frame.origin.x-PROPORTION414*13-numNameSize.width, 22, numNameSize.width, 42)];
    
    //付款收货评价按钮模块
     btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnConfirm setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-67, 71, 67, 25)];
    //两个数字进行拼接 中间用13568来做分割符
    NSString* string13568 = [NSString stringWithFormat:@"%@13568%@",entity.oid,entity.shopId];
    btnConfirm.tag = [string13568 integerValue];
    NSString *orderStatus = entity.orderStatus;//支付状态
    NSString *orderIsCancel = entity.isCancel;//是否取消
    NSString *orderIsRefuse = entity.isRefuse;//是否拒绝
    NSString *orderShippingStatus = entity.shipping_status;//配送状态
    NSString *orderIsDiscuss = entity.isDiscuss;//是否评论
    NSString *orderIsDel = entity.isDelete;//是否删除
    if([orderStatus intValue] == 0 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        [btnConfirm setTitle:@"立即付款" forState:UIControlStateNormal];
        [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnConfirm.layer.borderColor = [RGB(255, 80, 0) CGColor];
        btnConfirm.backgroundColor = RGB(255, 80, 0);
        btnConfirm.tag = section;
        [btnConfirm addTarget:self action:@selector(immediatePayment:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([orderStatus intValue] == 0 && [orderIsCancel intValue] == 1 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        [btnConfirm setTitle:@"交易结束" forState:UIControlStateNormal];
        [btnConfirm setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
        btnConfirm.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
        
    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        [btnConfirm setTitle:@"等待配送" forState:UIControlStateNormal];
        [btnConfirm setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
        btnConfirm.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
        
    }else if([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 1 && [orderIsDel intValue] == 0){
        [btnConfirm setTitle:@"到达确认" forState:UIControlStateNormal];
        [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnConfirm.layer.borderColor = [RGB(255, 80, 0) CGColor];
        btnConfirm.backgroundColor = RGB(255, 80, 0);
        [btnConfirm addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];

    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 1 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        [btnConfirm setTitle:@"商家拒单" forState:UIControlStateNormal];
        [btnConfirm setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
        btnConfirm.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];

    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 2 && [orderIsDel intValue] == 0){
        
            btnConfirm.hidden =NO;
            [btnConfirm setTitle:@"评论" forState:UIControlStateNormal];
            [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnConfirm.layer.borderColor = [RGB(255, 80, 0) CGColor];
            btnConfirm.backgroundColor = RGB(255, 80, 0);
            [btnConfirm addTarget:self action:@selector(btnCommentsClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 1 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 2 && [orderIsDel intValue] == 0) {
            [btnConfirm setTitle:@"已评论" forState:UIControlStateNormal];
            [btnConfirm setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
            btnConfirm.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
    }else if([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0  && [orderIsRefuse intValue] == 1 && [orderShippingStatus intValue] == 3 && [orderIsDel intValue] == 0) {
        [btnConfirm setTitle:@"已退款" forState:UIControlStateNormal];
        [btnConfirm setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
        btnConfirm.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
    }
    
    
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    btnConfirm.layer.borderWidth = 0.5;
    btnConfirm.layer.cornerRadius = 3;
    [view addSubview:btnConfirm];
    
    //取消订单模块
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    if([orderStatus intValue] == 0 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        [btnCancel setTitle:@"取消订单" forState:UIControlStateNormal];
        [btnCancel setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-142, 71, 67, 25)];
        
        [btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

    }else if ([orderStatus intValue] == 0 && [orderIsCancel intValue] == 1 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        [btnCancel setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-142, 71, 67, 25)];
        [btnCancel setTitle:@"删除订单" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(btndelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else if([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        btnCancel.hidden = YES;
        
    }else if([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 1 && [orderIsDel intValue] == 0){
        btnCancel.hidden = YES;
    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 1 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
        [btnCancel setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-142, 71, 67, 25)];
        [btnCancel setTitle:@"删除订单" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(btndelClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 1 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 2 && [orderIsDel intValue] == 0){
        
            [btnCancel setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-142, 71, 67, 25)];
            [btnCancel setTitle:@"删除订单" forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(btndelClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 1 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 2 && [orderIsDel intValue] == 0){
            [btnCancel setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-142, 71, 67, 25)];
            [btnCancel setTitle:@"删除订单" forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(btndelClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if([orderStatus intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsRefuse intValue] == 1 && [orderShippingStatus intValue] == 3 && [orderIsDel intValue] == 0){
        [btnCancel setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*20-142, 71, 67, 25)];
        [btnCancel setTitle:@"删除订单" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(btndelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //两个数字进行拼接 中间用13568来做分割符
    NSString* string = [NSString stringWithFormat:@"%@13568%@",entity.oid,entity.shopId];
    
    btnCancel.tag = [string integerValue];
    
    [btnCancel setTitleColor:FONTS_COLOR forState:UIControlStateNormal];
    btnCancel.layer.borderColor = [UIColorWithRGBA(114, 113, 113, 1) CGColor];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    btnCancel.layer.borderWidth = 0.5;
    btnCancel.layer.cornerRadius = 3;
    [view addSubview:btnCancel];
    
    //底部灰色模块
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, DEVICE_SCREEN_SIZE_WIDTH, 10)];
    [bgView setBackgroundColor:BGCOLOR_DEFAULT];
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
        NSString *payType = [NSString stringWithFormat:@"%ld",(long)buttonIndex];
        [self performPay:payType];
    }
    
}

// ----------------------------------------------------------------------------------------
// 立即支付 -- 支付宝支付、微信支付
// ----------------------------------------------------------------------------------------

- (void)performPay:(NSString *)payMethod {
    
    if ([payMethod isEqualToString:@"2"]) {
        /* 检测是否已安装微信 */
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请先安装微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alter show];
            return;
        }
    }
    NSLog(@"payMethod:%@",payMethod);
    //支付接口
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"user_id",
                         payMethod,@"trade_type",
                         oid,@"order_total_id",
                         shopId,@"shop_id",
                         nil];
    NSString *path = [NSString stringWithFormat:@"/Api/Order/rePay?"];
    NSLog(@"dic:%@",dic);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        if ([statusMsg intValue] == 201){
            //获取成功，无数据情况
            
        }else if ([statusMsg intValue] == 500){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"支付错误!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
            
        }else if ([statusMsg intValue] == 200){
            //支付宝支付
            NSString *payInfo = [[dic valueForKey:@"data"] valueForKey:@"Payinfo"];
            if ([payMethod isEqual:@"1"] && payInfo != nil) {
                //应用注册scheme,在Info.plist定义URL types
                NSString *appScheme = @"wx69b0d0dbc086b71f";
                
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:payInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    //没有安装支付宝时调用网页版，回调功能
                    NSString *memo = [resultDic valueForKey:@"memo"];
                    NSString *resultStatus = [resultDic valueForKey:@"resultStatus"];
                    NSInteger resultTag;
                    if ([resultStatus integerValue] == 9000) {
                        memo = @"支付成功";
                        resultTag = 0;
                    }else{
                        memo = @"支付失败";
                        resultTag = 1;
                    }
                    [self callbackResult:resultTag resultTitle:memo payType:@"1" errorContent:memo];
                }];
            }
            
        }else if([payMethod isEqual:@"2"]){
            NSDictionary *wxDic = [dic valueForKey:@"data"];
            PayReq *request = [[PayReq alloc] init];
            /** 商家向财付通申请的商家id */
            request.partnerId = [wxDic valueForKey:@"partnerid"];
            /** 预支付订单 */
            request.prepayId = [wxDic valueForKey:@"prepayid"];
            /** 商家根据财付通文档填写的数据和签名 */
            request.package = [wxDic valueForKey:@"package"];
            /** 随机串，防重发 */
            request.nonceStr= [wxDic valueForKey:@"noncestr"];
            /** 时间戳，防重发 */
            request.timeStamp= [[wxDic valueForKey:@"timestamp"] intValue];
            /** 商家根据微信开放平台文档对数据做的签名 */
            request.sign= [wxDic valueForKey:@"sign"];
            /*! @brief 发送请求到微信，等待微信返回onResp
             *
             * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
             * SendAuthReq、SendMessageToWXReq、PayReq等。
             * @param req 具体的发送请求，在调用函数后，请自己释放。
             * @return 成功返回YES，失败返回NO。
             */
            [WXApi sendReq: request];
        }
    }fail:^(NSError *error) {
        
    }];
    
    
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
     NSLog(@"btn:%@",btn);

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
    NSArray *array = [oid componentsSeparatedByString:@"13568"];
    NSLog(@"%@",[array objectAtIndex:1]);
    NSLog(@"%@",[array objectAtIndex:0]);
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"user_id",
                         [array objectAtIndex:1],@"shop_id",
                         [array objectAtIndex:0],@"order_total_id",
                         @"2",@"status",
                         nil];
    NSString *path = [NSString stringWithFormat:@"/Api/Shop/updStatus?"];
    NSLog(@"dic:%@",dic);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }else if ([statusMsg intValue] == 201){
            //获取成功，无数据情况
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"收货成功";
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            [self performSelector:@selector(refreshData:) withObject:nil afterDelay:1.0];
            
        }
        
    } fail:^(NSError *error) {
        
    }];

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
// 立即支付 -- 钱包支付
// ----------------------------------------------------------------------------------------
- (void)chooseWallet {
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"user_id",
                         @"3",@"trade_type",
                         oid,@"order_total_id",
                         shopId,@"shop_id",
                         nil];
    NSString *path = [NSString stringWithFormat:@"/Api/Order/rePay?"];
    NSLog(@"dic:%@",dic);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        if([statusMsg intValue] == 502){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"钱包余额不足";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }else if ([statusMsg intValue] == 201){
            //获取成功，无数据情况
            
        }else if ([statusMsg intValue] == 200){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"支付成功";
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            [self performSelector:@selector(refreshData:) withObject:nil afterDelay:1.0];
            
        }
    } fail:^(NSError *error) {
        
    }];
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
            //取消订单
            NSArray *array = [oid componentsSeparatedByString:@"13568"];
            NSLog(@"%@",[array objectAtIndex:1]);
            NSLog(@"%@",[array objectAtIndex:0]);
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 [Tools stringForKey:KEY_USER_ID],@"user_id",
                                 [array objectAtIndex:1],@"shop_id",
                                 [array objectAtIndex:0],@"order_total_id",
                                 @"3",@"status",
                                 nil];
            NSString *path = [NSString stringWithFormat:@"/Api/Shop/updStatus?"];
            NSLog(@"dic:%@",dic);
            [HYBNetworking updateBaseUrl:SERVICE_URL];
            [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
                
                NSDictionary *dic = response;
                NSString *statusMsg = [dic valueForKey:@"status"];
                if([statusMsg intValue] == 4001){
                    //弹框提示获取失败
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"获取失败!";
                    hud.yOffset = -50.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:2];
                    return;
                }else if ([statusMsg intValue] == 201){
                    //获取成功，无数据情况
                    
                }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText = @"取消成功";
                    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    [self performSelector:@selector(refreshData:) withObject:nil afterDelay:1.0];
                    
                }
                
            } fail:^(NSError *error) {
                
            }];
        }
    }
    
    if (alertView.tag == 120) {
        if (buttonIndex == 1) {
            NSArray *array = [oid componentsSeparatedByString:@"13568"];
            NSLog(@"%@",[array objectAtIndex:1]);
            NSLog(@"%@",[array objectAtIndex:0]);
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 [Tools stringForKey:KEY_USER_ID],@"user_id",
                                 [array objectAtIndex:1],@"shop_id",
                                 [array objectAtIndex:0],@"order_total_id",
                                 @"6",@"status",
                                 nil];
            NSString *path = [NSString stringWithFormat:@"/Api/Shop/updStatus?"];
            NSLog(@"dic:%@",dic);
            [HYBNetworking updateBaseUrl:SERVICE_URL];
            [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
                
                NSDictionary *dic = response;
                NSString *statusMsg = [dic valueForKey:@"status"];
                if([statusMsg intValue] == 4001){
                    //弹框提示获取失败
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"获取失败!";
                    hud.yOffset = -50.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:2];
                    return;
                }else if ([statusMsg intValue] == 201){
                    //获取成功，无数据情况
                    
                }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText = @"删除成功";
                    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    [self performSelector:@selector(refreshData:) withObject:nil afterDelay:1.0];
                    
                }
                
            } fail:^(NSError *error) {
                
            }];
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

//客户端支付成功回调页面
-(void)paySuccessMethod:(NSNotification*)notification{
    NSString *obj = [notification object];
    [self callbackResult:0 resultTitle:@"支付成功" payType:obj errorContent:@"支付成功"];
}
//客户端支付失败回调页面
-(void)payFailMethod:(NSNotification*)notification{
    NSString *obj = [notification object];
    [self callbackResult:1 resultTitle:@"支付失败" payType:obj errorContent:@"支付失败"];
}

// ----------------------------------------------------------------------------------------
// 网页页面支付状态回调
// ----------------------------------------------------------------------------------------
- (void)callbackResult:(NSInteger)result resultTitle:(NSString *)title payType:(NSString *)paytype errorContent:(NSString *)error {
    
    if (result == 0) {
        //支付成功
        PaySuccessViewController *sc= [[PaySuccessViewController alloc]initWithNibName:@"PaySuccessViewController" bundle:[NSBundle mainBundle]];
        sc.title = @"支付成功";
        [self.navigationController pushViewController:sc animated:YES];
    } else {
        //支付失败
        PayFailViewController *sf= [[PayFailViewController alloc]initWithNibName:@"PayFailViewController" bundle:[NSBundle mainBundle]];
        sf.title = @"支付失败";
        sf.payType = paytype;
        [self.navigationController pushViewController:sf animated:YES];
    }
}
@end
