//
//  OrdersDetailsController.m
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import "OrdersDetailsController.h"
#import "AllOrderCell.h"
#import "AllOrderEntity.h"
#import "ProductDetailViewController.h"
#import "OrderDetailEntity.h"
#import "SearchViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "PaySuccessViewController.h"
#import "PayFailViewController.h"
#import "CommentOrderViewController.h"

#define Reality_viewHeight ScreenHeight-ViewOrignY-40-50
#define Reality_viewWidth ScreenWidth
#define labWidth 80

@interface OrdersDetailsController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    UIView* headView;
    UILabel* orderTime;
    UILabel* remark;
    UILabel* orderNo;
    UILabel* orderStatus;
    UILabel* payType;
    UILabel* userLab;
    UILabel* phone;
    UILabel* address;
    UILabel* delivery;
    UIButton* canelBtn;//左边的按钮
    UIButton* submitBtn;//右边的按钮
    
}

@end

@implementation OrdersDetailsController
@synthesize mTableView = _mTableView;
@synthesize data = _data;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initTopView];
    
    [self loadData];
    [self initBottomBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessMethod:) name:@"alipaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailMethod:) name:@"alipayFail" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化UI

-(void)initTopView{
    
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewOrignY, DEVICE_SCREEN_SIZE_WIDTH, 275)];
    headView.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    //    [self.view addSubview:headView];
    
    //订单状态lab
    UILabel* orderStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, labWidth, 30)];
    orderStatusLab.text = @"订单状态";
    orderStatusLab.textAlignment = NSTextAlignmentCenter;
    orderStatusLab.font = [UIFont systemFontOfSize:12.0f];
    orderStatusLab.textColor = FONTS_COLOR102;
    orderStatusLab.backgroundColor = [UIColor whiteColor];
    [headView addSubview:orderStatusLab];
    //订单状态
    orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(orderStatusLab), 10, DEVICE_SCREEN_SIZE_WIDTH-labWidth, 30)];
    orderStatus.text = @"订单状态";
    orderStatus.textAlignment = NSTextAlignmentLeft;
    orderStatus.font = [UIFont systemFontOfSize:12.0f];
    orderStatus.textColor = FONTS_COLOR102;
    orderStatus.backgroundColor = [UIColor whiteColor];
    [headView addSubview:orderStatus];
    
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(orderStatus), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line1.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [headView addSubview:line1];
    
    //订单编号lab
    UILabel* orderNoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line1), labWidth, 30)];
    orderNoLab.text = @"订单编号";
    orderNoLab.textAlignment = NSTextAlignmentCenter;
    orderNoLab.font = [UIFont systemFontOfSize:12.0f];
    orderNoLab.textColor = FONTS_COLOR102;
    orderNoLab.backgroundColor = [UIColor whiteColor];
    [headView addSubview:orderNoLab];
    //订单编号
    orderNo = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(orderStatusLab), viewBottom(line1), DEVICE_SCREEN_SIZE_WIDTH-labWidth, 30)];
    orderNo.text = @"订单编号";
    orderNo.textAlignment = NSTextAlignmentLeft;
    orderNo.font = [UIFont systemFontOfSize:12.0f];
    orderNo.textColor = FONTS_COLOR102;
    orderNo.backgroundColor = [UIColor whiteColor];
    [headView addSubview:orderNo];
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(orderNo), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line2.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [headView addSubview:line2];
    
    //下单时间lab
    UILabel* orderTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line2), labWidth, 30)];
    orderTimeLab.text = @"下单时间";
    orderTimeLab.textAlignment = NSTextAlignmentCenter;
    orderTimeLab.font = [UIFont systemFontOfSize:12.0f];
    orderTimeLab.textColor = FONTS_COLOR102;
    orderTimeLab.backgroundColor = [UIColor whiteColor];
    [headView addSubview:orderTimeLab];
    //下单时间
    orderTime = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(orderStatusLab), viewBottom(line2), DEVICE_SCREEN_SIZE_WIDTH-labWidth, 30)];
    orderTime.text = @"下单时间";
    orderTime.textAlignment = NSTextAlignmentLeft;
    orderTime.font = [UIFont systemFontOfSize:12.0f];
    orderTime.textColor = FONTS_COLOR102;
    orderTime.backgroundColor = [UIColor whiteColor];
    [headView addSubview:orderTime];
    
    UILabel* line3 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(orderTime), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line3.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [headView addSubview:line3];
    
    //支付方式lab
    UILabel* payTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line3), labWidth, 30)];
    payTypeLab.text = @"支付方式";
    payTypeLab.textAlignment = NSTextAlignmentCenter;
    payTypeLab.font = [UIFont systemFontOfSize:12.0f];
    payTypeLab.textColor = FONTS_COLOR102;
    payTypeLab.backgroundColor = [UIColor whiteColor];
    [headView addSubview:payTypeLab];
    //支付方式
    payType = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(orderStatusLab), viewBottom(line3), DEVICE_SCREEN_SIZE_WIDTH-labWidth, 30)];
    payType.textAlignment = NSTextAlignmentLeft;
    payType.font = [UIFont systemFontOfSize:12.0f];
    payType.textColor = FONTS_COLOR102;
    payType.backgroundColor = [UIColor whiteColor];
    [headView addSubview:payType];
    
    UILabel* line4 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(payType), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line4.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [headView addSubview:line4];
    
    //备注lab
    UILabel* remarkLab = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line4), labWidth, 30)];
    remarkLab.text = @"备  注";
    remarkLab.textAlignment = NSTextAlignmentCenter;
    remarkLab.font = [UIFont systemFontOfSize:12.0f];
    remarkLab.textColor = FONTS_COLOR102;
    remarkLab.backgroundColor = [UIColor whiteColor];
    [headView addSubview:remarkLab];
    //备注
    remark = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(orderStatusLab), viewBottom(line4), DEVICE_SCREEN_SIZE_WIDTH-labWidth, 30)];
    remark.text = @"备注";
    remark.textAlignment = NSTextAlignmentLeft;
    remark.font = [UIFont systemFontOfSize:12.0f];
    remark.textColor = FONTS_COLOR102;
    remark.backgroundColor = [UIColor whiteColor];
    [headView addSubview:remark];
    
    UILabel* line5 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(remark), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line5.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [headView addSubview:line5];
    
    //收货地址
    UILabel* addressLab = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line5)+10, DEVICE_SCREEN_SIZE_WIDTH, 30)];
    addressLab.text = @"  收货地址";
    addressLab.textAlignment = NSTextAlignmentLeft;
    addressLab.font = [UIFont systemFontOfSize:11.0f];
    addressLab.textColor = FONTS_COLOR153;
    addressLab.backgroundColor = [UIColor whiteColor];
    [headView addSubview:addressLab];
    
    UILabel* line6 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(addressLab), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line6.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [headView addSubview:line6];
    
    //收货人
    userLab = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line6), DEVICE_SCREEN_SIZE_WIDTH-100, 30)];
    userLab.textAlignment = NSTextAlignmentLeft;
    userLab.font = [UIFont systemFontOfSize:14.0f];
    userLab.textColor = FONTS_COLOR102;
    userLab.backgroundColor = [UIColor whiteColor];
    [headView addSubview:userLab];
    //联系方式
    phone = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(userLab), viewBottom(line6), 100, 30)];
    phone.textAlignment = NSTextAlignmentLeft;
    phone.font = [UIFont systemFontOfSize:12.0f];
    phone.textColor = FONTS_COLOR102;
    phone.backgroundColor = [UIColor whiteColor];
    [headView addSubview:phone];
    
    //地址
    address = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(userLab), DEVICE_SCREEN_SIZE_WIDTH, 30)];
    address.text = @"  广东省 潮州市 潮安县 详细地址";
    address.textAlignment = NSTextAlignmentLeft;
    address.font = [UIFont systemFontOfSize:12.0f];
    address.textColor = FONTS_COLOR102;
    address.backgroundColor = [UIColor whiteColor];
    [headView addSubview:address];
    
    
    _mTableView.tableHeaderView = headView;
    
}
-(void)initBottomBtn{
    //左边的按钮
    canelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [canelBtn setFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT-40, DEVICE_SCREEN_SIZE_WIDTH/2, 40)];
    canelBtn.backgroundColor = UIColorWithRGBA(221, 221, 221, 1);
    [canelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [canelBtn setTitleColor:FONTS_COLOR102 forState:UIControlStateNormal];
    [canelBtn addTarget:self action:@selector(btndelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:canelBtn];
    
    
    //右边的按钮
    submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitBtn setFrame:CGRectMake(viewRight(canelBtn), DEVICE_SCREEN_SIZE_HEIGHT-40, DEVICE_SCREEN_SIZE_WIDTH/2, 40)];
    submitBtn.backgroundColor = UIColorWithRGBA(255, 80, 0, 1);
    [submitBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(btnCommentsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}
- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY, Reality_viewWidth, ScreenHeight-40) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.scrollsToTop = YES;
    _mTableView.backgroundColor = self.view.backgroundColor;
    _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_mTableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Reality_viewWidth, 70)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _mTableView.tableFooterView = tableFooterView;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}



#pragma mark - 加载数据

- (void)loadData {
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         _shopId,     @"shop_id",
                         _orderId,     @"order_total_id",
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"/Api/Order/showDetail?"];
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        NSLog(@"response:%@",response);
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }if([statusMsg intValue] == 201){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"无数据";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }if([statusMsg intValue] == 4002){
            [self showHUDText:@"获取失败!"];
        }else{
            [_data removeAllObjects];
            //订单数据
            _orderData = [[dic valueForKey:@"data"] valueForKey:@"order_info"];
            //地址数据
            _addressData = [[dic valueForKey:@"data"] valueForKey:@"address_info"];
            //店铺数据
            _shopData = [[dic valueForKey:@"data"] valueForKey:@"shop_info"];
            //优惠券数据
            _couponData = [[dic valueForKey:@"data"] valueForKey:@"coupon_info"];
            //订单编号
            _orderSn = [[dic valueForKey:@"data"] valueForKey:@"order_sn"];
            //支付状态
            _payStatus = [[dic valueForKey:@"data"] valueForKey:@"pay_status"];
            //支付类型
            _tradeType =[[dic valueForKey:@"data"] valueForKey:@"trade_type"];
            
            //cell数据添加
            if([[[dic valueForKey:@"data"] valueForKey:@"good_info"] count] > 0 && [[dic valueForKey:@"data"] valueForKey:@"good_info"] != nil){
                for(NSDictionary *allOrderEntity in [[dic valueForKey:@"data"] valueForKey:@"good_info"]){
                    NSLog(@"allOrderEntity:%@",allOrderEntity);
                    OrderDetailEntity *entity = [[OrderDetailEntity alloc]initWithAttributes:allOrderEntity];
                    [_data addObject:entity];
                    
                }
                [_mTableView reloadData];
                
                //下单时间
                orderTime.text = [_orderData valueForKey:@"create_time"];
                //备注
                remark.text = [_orderData valueForKey:@"user_remark"];
                //订单编号
                orderNo.text = _orderSn;
                //支付类型及支付方式
                if ([_payStatus integerValue] == 0) {
                    orderStatus.text = @"未支付";
                }else {
                    orderStatus.text = @"已支付";
                    //只有已支付了才能显示支付类型
                    if ([_tradeType integerValue] == 1) {
                        payType.text =  @"支付宝支付";
                    }else {
                        payType.text =  @"微信支付";
                    }
                }
                //收货人
                userLab.text = [NSString stringWithFormat:@"   %@",[_addressData valueForKey:@"guest_name"]];
                //联系方式
                phone.text = [_addressData valueForKey:@"mobile"];
                //收货地址
                address.text = [NSString stringWithFormat:@"   %@ %@ %@ %@",[_addressData valueForKey:@"province"],[_addressData valueForKey:@"city"],[_addressData valueForKey:@"area"],[_addressData valueForKey:@"address"]];
                
                NSString *orderStatus1 = _payStatus;//支付状态
                NSString *orderIsCancel = [_orderData valueForKey:@"is_cancel_order"];//是否取消
                NSString *orderIsRefuse = [_orderData valueForKey:@"is_denial_orders"];//是否拒绝
                NSString *orderShippingStatus = [_orderData valueForKey:@"shipping_status"];//配送状态
                NSString *orderIsDiscuss = [_orderData valueForKey:@"is_discuss"];//是否评论
                NSString *orderIsDel = [_orderData valueForKey:@"is_del_order"];//是否删除
                
                //
                if([orderStatus1 intValue] == 0 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
                    //立即付款
                    //左边按钮
                    [canelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    canelBtn.tag = 1;
                    //右边按钮
                    [submitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                    submitBtn.tag = 1;
                    
                }else if ([orderStatus1 intValue] == 0 && [orderIsCancel intValue] == 1 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
                    //交易取消
                    //左边按钮
                    [canelBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    canelBtn.tag = 2;
                    //右边按钮
                    [submitBtn setTitle:@"交易取消" forState:UIControlStateNormal];
                    submitBtn.enabled = NO;
                    [submitBtn setFrame:CGRectMake(viewRight(canelBtn), DEVICE_SCREEN_SIZE_HEIGHT-40, DEVICE_SCREEN_SIZE_WIDTH/2, 40)];
                    
                    
                }else if([orderStatus1 intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
                    //到达确认
                    //左边按钮
                    canelBtn.hidden = YES;
                    //右边按钮
                    submitBtn.enabled = NO;
                    [submitBtn setTitle:@"等待配送" forState:UIControlStateNormal];
                    [submitBtn setFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT-40, DEVICE_SCREEN_SIZE_WIDTH, 40)];
                    
                    
                }else if([orderStatus1 intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 1 && [orderIsDel intValue] == 0){
                    //到达确认
                    //左边按钮
                    canelBtn.hidden = YES;
                    //右边按钮
                    [submitBtn setTitle:@"到达确认" forState:UIControlStateNormal];
                    [submitBtn setFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT-40, DEVICE_SCREEN_SIZE_WIDTH, 40)];
                    submitBtn.tag = 2;
                    
                    
                }else if ([orderStatus1 intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 1 && [orderShippingStatus intValue] == 0 && [orderIsDel intValue] == 0){
                    //商家拒单
                    //左边按钮
                    [canelBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    canelBtn.tag = 2;
                    //右边按钮
                    [submitBtn setTitle:@"商家拒单" forState:UIControlStateNormal];
                    submitBtn.enabled = NO;
                    [submitBtn setFrame:CGRectMake(viewRight(canelBtn), DEVICE_SCREEN_SIZE_HEIGHT-40, DEVICE_SCREEN_SIZE_WIDTH/2, 40)];
                    
                    
                }else if ([orderStatus1 intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 0 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 2 && [orderIsDel intValue] == 0){
                    
                        //评论
                        //左边按钮
                    canelBtn.hidden = YES;
//                        [canelBtn setTitle:@"删除订单" forState:UIControlStateNormal] ;
//                        canelBtn.tag = 2;
                        //右边按钮
                    submitBtn.hidden = YES;
//                        [submitBtn setTitle:@"评论" forState:UIControlStateNormal];
//                        submitBtn.tag = 3;
                    
                    
                }else if([orderStatus1 intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsDiscuss intValue] == 1 && [orderIsRefuse intValue] == 0 && [orderShippingStatus intValue] == 2 && [orderIsDel intValue] == 0) {
                        //评论
                        //左边按钮
                        [canelBtn setTitle:@"删除订单" forState:UIControlStateNormal] ;
                        canelBtn.tag = 2;
                        //右边按钮
                        [submitBtn setTitleColor:UIColorWithRGBA(221, 221, 221, 1) forState:UIControlStateNormal];
                        [submitBtn setTitle:@"已评论" forState:UIControlStateNormal];
                    
                }else if([orderStatus1 intValue] == 1 && [orderIsCancel intValue] == 0 && [orderIsRefuse intValue] == 1 && [orderShippingStatus intValue] == 3 && [orderIsDel intValue] == 0) {
                    //评论
                    canelBtn.hidden = YES;
                    //右边按钮
                    submitBtn.enabled = NO;
                    [submitBtn setTitle:@"已退款" forState:UIControlStateNormal];
                    [submitBtn setFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT-40, DEVICE_SCREEN_SIZE_WIDTH, 40)];
                    
                }
                
                
                
                
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - SDRefresh

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    [refreshHeader addToScrollView:_mTableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadData];
            //            [_mTableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}
-(void)refeshOrder{
    //    [self loadData];
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
        //        [self loadData];
        [self.refreshFooter endRefreshing];
    });
}

- (void)dealloc
{
    [self.refreshHeader removeFromSuperview];
    [self.refreshFooter removeFromSuperview];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllOrderCell *cell = (AllOrderCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AllOrderCell";
    AllOrderCell *cell = (AllOrderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllOrderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([_data count] > 0) {
        
        OrderDetailEntity *entity = [_data objectAtIndex:[indexPath row]];
        
        if ([self isBlankString:entity.goodImage]) {
            cell.shopImage.image = [UIImage imageNamed:@"暂无图片"];
        } else {
            [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:entity.goodImage] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        }
        cell.shopImage.layer.borderWidth = 0.5;
        cell.shopImage.layer.borderColor = [LINECOLOR_DEFAULT CGColor];
        
        cell.shopName.numberOfLines = 2;
        cell.shopName.text = entity.goodName;
        cell.shopName.textColor = UIColorWithRGBA(102, 100, 100, 1);
        
        cell.shopPrice.text = [NSString stringWithFormat:@"¥ %0.2f",[entity.goodPrice floatValue]];
        cell.shopPrice.textAlignment = NSTextAlignmentLeft;
        
        cell.shopNum.text = [NSString stringWithFormat:@"x%@",entity.nums];
        cell.shopNum.textAlignment = NSTextAlignmentRight;
    }
    return cell;
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
    return 130;
}

// ----------------------------------------------------------------------------------------
// tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
// 设置分区 Header 展示内容
// ----------------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 32)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    //分割线
    EMAsyncImageView *line1 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, 0,DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [line1 setBackgroundColor:UIColorWithRGBA(238, 239, 239, 1)];
    [view addSubview:line1];
    EMAsyncImageView *line2 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, 31,DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [line2 setBackgroundColor:UIColorWithRGBA(238, 239, 239, 1)];
    [view addSubview:line2];
    
    //店铺模块
    EMAsyncImageView *shopLogo = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(PROPORTION414*20, 7, 16, 16)];
    
    if ([self isBlankString:[_shopData valueForKey:@"sj_image"]]) {
        shopLogo.image = [UIImage imageNamed:@"store"];
    } else {
        
        NSString *images = [_shopData valueForKey:@"sj_image"];
        [shopLogo sd_setImageWithURL:[NSURL URLWithString:images] placeholderImage:[UIImage imageNamed:@"store"]];
    }
    [view addSubview:shopLogo];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PROPORTION414*30+17, 0, 81, 32)];
    label.textColor = UIColorWithRGBA(102, 102, 102, 1);
    label.font = [UIFont boldSystemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%@",[_shopData valueForKey:@"sj_shop_name"]];
    [view addSubview:label];
    
    
    
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 120)];
    view.backgroundColor = [UIColor whiteColor];
    EMAsyncImageView *line1 = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, 0,DEVICE_SCREEN_SIZE_WIDTH, 1)];
    [line1 setBackgroundColor:UIColorWithRGBA(238, 239, 239, 1)];
    [view addSubview:line1];
    //配送费lab
    UILabel* deliveryLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, labWidth, 30)];
    deliveryLab.text = @"配送费";
    deliveryLab.textAlignment = NSTextAlignmentLeft;
    deliveryLab.font = [UIFont systemFontOfSize:12.0f];
    deliveryLab.textColor = FONTS_COLOR102;
    [view addSubview:deliveryLab];
    //配送费
    delivery = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(deliveryLab), 0, DEVICE_SCREEN_SIZE_WIDTH-labWidth-20, 30)];
    delivery.textAlignment = NSTextAlignmentRight;
    delivery.text = [NSString stringWithFormat:@"%@元",[_orderData valueForKey:@"freight_amount"]];
    delivery.font = [UIFont systemFontOfSize:12.0f];
    delivery.textColor = FONTS_COLOR102;
    [view addSubview:delivery];
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(deliveryLab), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line2.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [view addSubview:line2];
    
    //优惠券lab
    UILabel* couponsLab = [[UILabel alloc]initWithFrame:CGRectMake(10, viewBottom(line2), labWidth, 30)];
    couponsLab.text = @"优惠券";
    couponsLab.textAlignment = NSTextAlignmentLeft;
    couponsLab.font = [UIFont systemFontOfSize:12.0f];
    couponsLab.textColor = FONTS_COLOR102;
    [view addSubview:couponsLab];
    //优惠券
    UILabel* coupons = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(couponsLab), viewBottom(line2), DEVICE_SCREEN_SIZE_WIDTH-labWidth-20, 30)];
    coupons.text = [NSString stringWithFormat:@"优惠%@元",[_couponData valueForKey:@"exp_value"]];
    coupons.textAlignment = NSTextAlignmentRight;
    coupons.font = [UIFont systemFontOfSize:12.0f];
    coupons.textColor = FONTS_COLOR102;
    [view addSubview:coupons];
    
    UILabel* line3 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(couponsLab), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line3.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [view addSubview:line3];
    
    //使用账户余额lab
    UILabel* moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, viewBottom(line3), labWidth, 30)];
    moneyLab.text = @"使用账户余额";
    moneyLab.textAlignment = NSTextAlignmentLeft;
    moneyLab.font = [UIFont systemFontOfSize:12.0f];
    moneyLab.textColor = FONTS_COLOR102;
    [view addSubview:moneyLab];
    //使用账户余额
    UILabel* money = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(moneyLab), viewBottom(line3), DEVICE_SCREEN_SIZE_WIDTH-labWidth-20, 30)];
    money.text = @"使用10元";
    money.textAlignment = NSTextAlignmentRight;
    money.font = [UIFont systemFontOfSize:12.0f];
    money.textColor = FONTS_COLOR102;
    [view addSubview:money];
    
    UILabel* line4 = [[UILabel alloc]initWithFrame:CGRectMake(5, viewBottom(moneyLab), DEVICE_SCREEN_SIZE_WIDTH-10, 1)];
    line4.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    [view addSubview:line4];
    
    //实付
    UILabel* payLab = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line4), DEVICE_SCREEN_SIZE_WIDTH-15, 40)];
    payLab.text = [NSString stringWithFormat:@"实付：￥%@",[_orderData valueForKey:@"real_amount"]];
    payLab.textAlignment = NSTextAlignmentRight;
    payLab.font = [UIFont systemFontOfSize:12.0f];
    payLab.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    payLab.textColor = UIColorWithRGBA(255, 80, 0, 1);
    [view addSubview:payLab];
    
    UILabel* Lab = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(payLab), viewBottom(line4), 15, 40)];
    Lab.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    Lab.textColor = UIColorWithRGBA(255, 80, 0, 1);
    [view addSubview:Lab];
    
    return view;
}
// ----------------------------------------------------------------------------------------
// 立即支付 -- 钱包支付
// ----------------------------------------------------------------------------------------
- (void)chooseWallet {
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"user_id",
                         @"3",@"trade_type",
                         _orderId,@"order_total_id",
                         _shopId,@"shop_id",
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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"支付成功";
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            //返回前一个页面
            [self.navigationController popViewControllerAnimated:YES];
            //刷新订单页面数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshByOrderDetail" object:nil];
            
        }
    } fail:^(NSError *error) {
        
    }];
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
                         _orderId,@"order_total_id",
                         _shopId,@"shop_id",
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

//左边按钮事件
-(IBAction)btndelClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn:%ld",(long)btn.tag);
    //取消订单
    if ((long)btn.tag == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定取消订单？"message:@"取消之后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag=110;
        [alert show];
        //删除订单
    }else if ((long)btn.tag == 2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除订单？"message:@"删除之后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag=120;
        [alert show];
    }
}
//右边按钮事件
-(IBAction)btnCommentsClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn:%ld",(long)btn.tag);
    if ((long)btn.tag == 1) {
        //立即支付
        UIActionSheet *paySheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"钱包支付" otherButtonTitles:@"支付宝支付", @"微信支付", nil];
        paySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        [paySheet showInView:self.view];
    }
    if ((long)btn.tag == 2) {
        //到达确认
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                             [Tools stringForKey:KEY_USER_ID],@"user_id",
                             _shopId,@"shop_id",
                             _orderId,@"order_total_id",
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
                //刷新订单页面数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshByOrderDetail" object:nil];
                [self performSelector:@selector(backClick:) withObject:nil afterDelay:1.0];
                
            }
            
        } fail:^(NSError *error) {
            
        }];
    }if ((long)btn.tag == 3) {
        
        //评论(暂时无实现)
        CommentOrderViewController * CommentslView = [[CommentOrderViewController alloc]init];
        CommentslView.data = _data;
        CommentslView.title = @"订单评价";
        CommentslView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CommentslView animated:YES];
    }
    
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 110) {
        
        if (buttonIndex == 1) {
            //取消订单
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 [Tools stringForKey:KEY_USER_ID],@"user_id",
                                 _shopId,@"shop_id",
                                 _orderId,@"order_total_id",
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
                    //返回前一个页面
                    [self.navigationController popViewControllerAnimated:YES];
                    //刷新订单页面数据
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshByOrderDetail" object:nil];
                    
                }
                
            } fail:^(NSError *error) {
                
            }];
        }
    }
    
    if (alertView.tag == 120) {
        if (buttonIndex == 1) {
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 [Tools stringForKey:KEY_USER_ID],@"user_id",
                                 _shopId,@"shop_id",
                                 _orderId,@"order_total_id",
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
                    //返回前一个页面
                    [self.navigationController popViewControllerAnimated:YES];
                    //刷新订单页面数据
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshByOrderDetail" object:nil];
                    
                }
                
            } fail:^(NSError *error) {
                
            }];
        }
    }
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

// 返回上页
- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
