//
//  ConfirmOrderViewController.m
//  确认订单
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ConfirmOrderEntity.h"
#import "ConfirmOrderCell.h"
//#import "AddressDriveViewController.h"
//#import "AddressEntity.h"
//#import "KimsVolumeViewController.h"
//#import "KimsVolumeEntity.h"
#import "MyCartViewController.h"
//#import "ProductDetailsViewController.h"
//#import "PaySuccessViewController.h"
//#import "PayFailureViewController.h"
//#import "AppPay.h"
//#import "Pingpp.h"
#import "AddressModuleView.h"
#import "PaymentModuleView.h"
#import "ConfirmSubmitView.h"
#import "ConfirmSectionHeaderView.h"
#import "ConfirmSectionFooterView.h"
#import <AlipaySDK/AlipaySDK.h>

static CGFloat tableViewSectionHeaderHeight = 35;
static CGFloat tableViewSectionFooterHeight = 105;
static CGFloat submitViewHeight = 52;

@interface ConfirmOrderViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    //    , PayDelegate
    UIView *tableHeaderView;
    AddressModuleView   *addressView;
    PaymentModuleView   *paymentView;
    ConfirmSubmitView   *submitView;
    NSString *outTradeNo;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation ConfirmOrderViewController


#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coupon:) name:@"myCoupon"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myAddress:) name:@"myaddress"object:nil];
    
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //初始化data
    _data = [[NSMutableArray alloc]init];
    
    //设置tableView框架
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewOrignY-tableViewSectionHeaderHeight, self.view.frame.size.width, self.view.frame.size.height-ViewOrignY+tableViewSectionHeaderHeight+tableViewSectionFooterHeight-submitViewHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BGCOLOR_DEFAULT;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(tableViewSectionHeaderHeight, 0, tableViewSectionFooterHeight, 0);
    [self.view addSubview:_tableView];
    
    _tableView.sectionHeaderHeight = tableViewSectionHeaderHeight;
    _tableView.sectionFooterHeight = tableViewSectionFooterHeight;
    
    //绘制视图
    [self drawSubmitView];
    [self drawHeaderView];
    [self drawFooterView];
    
    //判断数据来源
    //    if (_from == 1) {
    //        [self loadProData];
    //    } else if (_from == 2) {
    [self loadCartData];
    //    } else if (_from == 3) {
    //        [self loadComboData];
    //    }
    
}

// ----------------------------------------------------------------------------------------
// 视图即将可见时调用
// ----------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxCallback:) name:@"weixinCallback_ConfirmOrder"object:nil];
    //    [Tools saveInteger:1 forKey:KEY_WX_CALLBACK];
}

// ----------------------------------------------------------------------------------------
//  视图被解散后调用，覆盖或以其他方式隐藏
// ----------------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixinCallback_ConfirmOrder" object:nil];
}

#pragma mark - 执行通知

// ----------------------------------------------------------------------------------------
// 通知 - 微信支付回调
// ----------------------------------------------------------------------------------------
- (void)wxCallback:(NSNotification*)notification {
    
    //    [self queryPayStatus];
    //
    //    NSArray *obj = [notification object];
    //
    //    NSString *resultStr = [obj objectAtIndex:0];
    //    NSInteger result = [resultStr integerValue];
    //
    //    //回调成功时,刷新数据
    //    if (result == 0) {
    //        //漏斗-支付成功
    //        [Statistical event:@"PaySuccess"];
    //
    //        PaySuccessViewController *allOrderView = [[PaySuccessViewController alloc]init];
    //        allOrderView.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:allOrderView animated:YES];
    //    } else {
    //        PayFailureViewController *payFailureView = [[PayFailureViewController alloc]init];
    //        payFailureView.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:payFailureView animated:YES];
    //    }
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateOrderNumber" object:nil];    //通知订单数量更新
}

// ----------------------------------------------------------------------------------------
// 通知 - 优惠券数据
// ----------------------------------------------------------------------------------------
- (void)coupon:(NSNotification*)notification {
    
    //    KimsVolumeEntity *entity = [notification object];
    //
    //    paymentView.vouchersValue.text = [NSString stringWithFormat:@"减免 %@ 元",entity.m];
    //    paymentView.vouchersNO = entity.couponNo;
    //
    //    //记录优惠金额
    //    submitView.coupons = [entity.m floatValue];
    //    [submitView reloadDisplayData];
}

// ----------------------------------------------------------------------------------------
// 通知 - 地址数据
// ----------------------------------------------------------------------------------------
- (void)myAddress:(NSNotification*)notification {
    
    //    AddressEntity *entity = [notification object];//获取到传递的对象
    //
    //    NSString *addId     = entity.addId;
    //    NSString *name      = entity.name;
    //    NSString *phone     = entity.phone;
    //    NSString *address   = entity.address;
    //    NSString *isRemote  = entity.isRemote;
    //
    //    [self setAddressID:addId nameText:name phoneText:phone addressText:address remoteText:isRemote];
}

#pragma mark - 绘制UI

// ----------------------------------------------------------------------------------------
// 底部提交模块
// ----------------------------------------------------------------------------------------
- (void)drawSubmitView {
    
    submitView = [[ConfirmSubmitView alloc]initWithFrame:CGRectMake(0, ScreenHeight - submitViewHeight, ScreenWidth, submitViewHeight)];
    [submitView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:submitView];
    
    [submitView.submitButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
}

// ----------------------------------------------------------------------------------------
// tableView - HeaderView
// ----------------------------------------------------------------------------------------
- (void)drawHeaderView {
    
    tableHeaderView = [[UIView alloc]init];
    
    //收货信息模块
    addressView = [[AddressModuleView alloc]initWithFrame:CGRectMake(0, tableViewSectionHeaderHeight, ScreenWidth, 90)];
    [addressView.button addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:addressView];
    
    //支付模块
    paymentView = [[PaymentModuleView alloc]initWithFrame:CGRectMake(0, viewBottom(addressView)+10, ScreenWidth, ViewHeight(paymentView)+60) delegate:self];
    [paymentView.vouchersButton addTarget:self action:@selector(couponsClick:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:paymentView];
    
    //显示钱包余额
    //    NSString *userWalletBalance = [Tools stringForKey:User_WalletBalance];
    NSString *userWalletBalance = @"123";
    if (userWalletBalance) {
        userWalletBalance = [NSString stringWithFormat:@"¥ %@",userWalletBalance];
    } else {
        userWalletBalance = @"¥ 0.0";
    }
    paymentView.walletBalance.text = userWalletBalance;
    
    [self loadDefaultAddressData];
    [self loadWelletBalanceData];
}

// ----------------------------------------------------------------------------------------
// tableView - FooterView
// ----------------------------------------------------------------------------------------
- (void)drawFooterView {
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableViewSectionFooterHeight)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableFooterView = tableFooterView;
}

#pragma mark - 页面跳转

- (void)addressClick:(id)sender {
    
    //    AddressDriveViewController *addressDrive = [[AddressDriveViewController alloc]init];
    //    addressDrive.title = @"地址管理";
    //    addressDrive.identify = @"1";
    //    addressDrive.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:addressDrive animated:YES];
    
}

- (void)couponsClick:(id)sender {
    
    //    KimsVolumeViewController *addressDrive = [[KimsVolumeViewController alloc]init];
    //    addressDrive.title = @"代金劵";
    //    addressDrive.prices = [NSString stringWithFormat:@"%f",submitView.total];
    //    addressDrive.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:addressDrive animated:YES];
    
}


#pragma mark - 获取数据

// ----------------------------------------------------------------------------------------
// loadWelletBalanceData   :   获取钱包余额
// ----------------------------------------------------------------------------------------
- (void)loadWelletBalanceData {
    //
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [Tools stringForKey:KEY_USER_ID],              @"uid",
    //                         @"10000000",                                   @"pageNo",
    //                         nil];
    //    NSString *xpoint = @"userWelletDetail.do?";
    //    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //        if (error) {
    //        } else {
    //
    //            CGFloat balanceFloat = [[respond.respondData valueForKey:@"balance"]floatValue];
    //            NSString *balanceStr = [NSString stringWithFormat:@"%0.1f",balanceFloat];
    //            [Tools saveObject:balanceStr forKey:User_WalletBalance];
    //
    //            NSString *userWalletBalance = [Tools stringForKey:User_WalletBalance];
    //            paymentView.walletBalance.text = [NSString stringWithFormat:@"¥ %@",userWalletBalance];
    //        }
    //    }];
}

// ----------------------------------------------------------------------------------------
// 获取购物车数据
// ----------------------------------------------------------------------------------------
- (void)loadCartData {
    NSLog(@"_submitStr:%@",_submitStr);
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         @"ios",          @"type",
                         _submitStr,                                @"cartIds",
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         nil];
    NSString *path = [NSString stringWithFormat:@"/Api/Cart/Commit?"];
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
        }else{
            CGFloat totalPrice = 0;
            CGFloat logisticsCost = 0;
            
            //            BOOL pursePay = [[respond.respondData valueForKey:@"isWallte"]boolValue];
            BOOL pursePay = YES;//判断是否使用钱包
            [paymentView allowedToUseTheWallet:pursePay];
            
            NSArray *array = [[dic valueForKey:@"data"]valueForKey:@"cart_info"];
            
            for (NSDictionary *temList in array) {
                NSLog(@"temList:%@",temList);
                ConfirmOrderEntity *entity = [[ConfirmOrderEntity alloc]initWithAttributes:temList];
                entity.note = @"";
                [_data addObject:entity];
//                for(int j=0;j<[[entity.products valueForKey:@"good_price"] count];j++){
//                    NSString *goodPrice = [entity.products valueForKey:@"good_price"] indexOfObject:j];
//                    NSString *nums = [entity.products valueForKey:@"nums"] indexOfObject:j];
//                   totalPrice += [goodPrice floatValue]*[nums floatValue];
//                }
            
            totalPrice += 100;
                //                logisticsCost += [entity.espressPrice integerValue];
            }
            
            submitView.total = totalPrice;          //记录总价
            submitView.freight = logisticsCost;     //记录物理费
            [submitView reloadDisplayData];
            
            [_tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [Tools stringForKey:KEY_USER_ID],          @"uid",
    //                         _submitStr,                                @"cids",
    //                         nil];
    //    NSString *xpoint = @"orderProduct.do?";
    //    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //        if (error) {
    //        } else {
    //
    //            if (respond.result == 1) {
    //
    //                CGFloat totalPrice = 0;
    //                CGFloat logisticsCost = 0;
    //
    //                BOOL pursePay = [[respond.respondData valueForKey:@"isWallte"]boolValue];
    //                [paymentView allowedToUseTheWallet:pursePay];
    //
    //                NSArray *array = [respond.respondData valueForKey:@"result"];
    //
    //                for (NSDictionary *temList in array) {
    //                    ConfirmOrderEntity *entity = [[ConfirmOrderEntity alloc]initWithAttributes:temList];
    //                    entity.note = @"";
    //                    [_data addObject:entity];
    //
    //                    totalPrice += [entity.sumPrice floatValue];
    //                    logisticsCost += [entity.espressPrice integerValue];
    //                }
    //
    //                submitView.total = totalPrice;          //记录总价
    //                submitView.freight = logisticsCost;     //记录物理费
    //                [submitView reloadDisplayData];
    //
    //                [_tableView reloadData];
    //            } else {
    //                [self.navigationController popToRootViewControllerAnimated:YES];
    //            }
    //
    //        }
    //        [self endLoading];
    //    }];
}

// ----------------------------------------------------------------------------------------
// 获取立即购买数据
// ----------------------------------------------------------------------------------------
- (void)loadProData {
    
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [Tools stringForKey:KEY_USER_ID],          @"uid",
    //                         _proNum,                                   @"num",
    //                         _proId,                                    @"pid",
    //                         nil];
    //    NSString *xpoint = @"addPurchase.do?";
    //    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //        if (error) {
    //        } else {
    //
    //            if (respond.result == 1) {
    //
    //                for (NSDictionary *temList in respond.respondArray) {
    //                    ConfirmOrderEntity *entity = [[ConfirmOrderEntity alloc]initWithAttributes:temList];
    //                    [_data addObject:entity];
    //                }
    //
    //                ConfirmOrderEntity *entity = [_data objectAtIndex:0];
    //                NSArray *products = [entity.products objectAtIndex:0];
    //
    //                CGFloat totalPrice = [[products valueForKey:@"allPrice"] floatValue];
    //                CGFloat logisticsCost = [entity.espressPrice floatValue];
    //
    //                submitView.total = totalPrice;          //记录总价
    //                submitView.freight = logisticsCost;     //记录物理费
    //                [submitView reloadDisplayData];
    //
    //                [_tableView reloadData];
    //            } else {
    //                [self.navigationController popToRootViewControllerAnimated:YES];
    //            }
    //
    //        }
    //        [self endLoading];
    //    }];
}

// ----------------------------------------------------------------------------------------
// 获取套餐数据
// ----------------------------------------------------------------------------------------
- (void)loadComboData {
    
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [Tools stringForKey:KEY_USER_ID],          @"uid",
    //                         _proId,                                    @"pkgId",
    //                         nil];
    //    NSString *xpoint = @"addPkgPurchase.do?";
    //    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //        if (error) {
    //        } else {
    //
    //            if (respond.result == 1) {
    //
    //                NSArray *array = respond.respondArray;
    //
    //                for (NSDictionary *temList in array) {
    //                    ConfirmOrderEntity *entity = [[ConfirmOrderEntity alloc]initWithAttributes:temList];
    //                    [_data addObject:entity];
    //                }
    //
    //                NSDictionary *dic = [array objectAtIndex:0];
    //
    //                CGFloat totalPrice = [[dic valueForKey:@"sumPrice"] floatValue];
    //                CGFloat logisticsCost = [[dic valueForKey:@"espressPrice"] floatValue];
    //
    //                submitView.total = totalPrice;          //记录总价
    //                submitView.freight = logisticsCost;     //记录物理费
    //                [submitView reloadDisplayData];
    //
    //                [_tableView reloadData];
    //            } else {
    //                [self.navigationController popToRootViewControllerAnimated:YES];
    //            }
    //
    //        }
    //        [self endLoading];
    //    }];
}

// ----------------------------------------------------------------------------------------
// 获取默认地址
// ----------------------------------------------------------------------------------------
- (void)loadDefaultAddressData {
    
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         nil];
    NSString *path = [NSString stringWithFormat:@"/Api/User/showAddress?"];
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
        }else{
            NSString *addId     = [[[dic valueForKey:@"data"]objectAtIndex:0] valueForKey:@"id"];
            NSString *name      = [[[dic valueForKey:@"data"]objectAtIndex:0] valueForKey:@"guest_name"];
            NSString *phone     = [[[dic valueForKey:@"data"]objectAtIndex:0] valueForKey:@"mobile"];
            NSString *address   = [[[dic valueForKey:@"data"]objectAtIndex:0] valueForKey:@"address"];
            
            [self setAddressID:addId nameText:name phoneText:phone addressText:address remoteText:@"1"];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [Tools stringForKey:KEY_USER_ID],          @"uid",
    //                         nil];
    //    NSString *xpoint = @"defaultAddress.do?";
    //    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //        if (error) {
    //
    //        } else {
    //
    //            if (respond.result == 1) {
    //
    //                NSString *addId     = [respond.respondData valueForKey:@"addId"];
    //                NSString *name      = [respond.respondData valueForKey:@"name"];
    //                NSString *phone     = [respond.respondData valueForKey:@"tel"];
    //                NSString *address   = [respond.respondData valueForKey:@"address"];
    //                NSString *isRemote  = [respond.respondData valueForKey:@"isRemote"];
    //
    //                [self setAddressID:addId nameText:name phoneText:phone addressText:address remoteText:isRemote];
    //            }
    //        }
    //    }];
}

// ----------------------------------------------------------------------------------------
// 写入联系信息
// ----------------------------------------------------------------------------------------
- (void)setAddressID:(NSString *)addressID nameText:(NSString *)name phoneText:(NSString *)phone addressText:(NSString *)address remoteText:(NSString *)remote {
    //记录 是否偏远地区
    submitView.isRemote = [remote boolValue];
    //刷新显示数据
    [submitView reloadDisplayData];
    
    //如果地址id存在 显示新地址信息
    if (addressID != nil) {
        [addressView setAddressID:addressID nameText:name phoneText:phone addressText:address];
        [paymentView setFrame:CGRectMake(0, viewBottom(addressView)+10, ScreenWidth, ViewHeight(paymentView))];
    }
    
    //重置tableHeaderView高度
    [tableHeaderView setFrame:CGRectMake(0, 0, ScreenWidth, viewBottom(paymentView)+10)];
    [self.tableView setTableHeaderView:tableHeaderView];
}

#pragma mark - 提交数据(下单)

// ----------------------------------------------------------------------------------------
// 提交订单
// ----------------------------------------------------------------------------------------
- (void)confirmClick:(id)sender {
    
    //    if ([paymentView.payType isEqualToString:@"2"]) {
    //        /* 检测是否已安装微信 */
    //        if (![WXApi isWXAppInstalled]) {
    //            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请先安装微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //            [alter show];
    //            return;
    //        }
    //    }
    
    //检查有无收货地址
    if (addressView.addressID == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请设置收货地址";
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;
    }
    
    NSMutableArray *noteArray = [[NSMutableArray alloc]init];
    //商家id:留言 保存成字符串
    for (int i = 0; i < _data.count; i ++) {
        ConfirmOrderEntity *entity = [_data objectAtIndex:i];
        
        NSString *noteStr;
        NSString *activityStr;
        //        if (entity.note.length == 0) {
        //            noteStr = @" ";
        //        } else {
        //            noteStr = entity.note;
        //        }
        noteStr = @" ";
        activityStr =[NSString stringWithFormat:@"%@-%@",entity.shopId,entity.shopName];
        NSString *stoNoteStr = [NSString stringWithFormat:@"%@:%@",activityStr,noteStr];
        [noteArray addObject:stoNoteStr];
    }
    NSString *noteStr = [noteArray componentsJoinedByString:@","];
    
    //锁定提交按钮 避免连续点击
    submitView.submitButton.userInteractionEnabled = NO;
    
    switch (_from) {
        case 1: {
            [self submitProData:noteStr];
        }   break;
        case 2: {
            [self submitCartData:noteStr];
        }   break;
        case 3: {
            [self submitComboData:noteStr];
        }   break;
        default:
            break;
    }
    
}

// ----------------------------------------------------------------------------------------
// 立即购买订单提交
// ----------------------------------------------------------------------------------------
- (void)submitProData:(NSString *)noteStr {
    
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [Tools stringForKey:KEY_USER_ID],          @"uid",
    //                         addressView.addressID,                     @"addressId",
    //                         _proId,                                     @"pid",
    //                         _proNum,                                    @"num",
    //                         noteStr,                                   @"messages",
    //                         @"1",                                      @"consigneeType",
    //                         paymentView.payType,                       @"payMethod",
    //                         paymentView.walletType,                    @"wallet",
    //                         paymentView.vouchersNO,                    @"couponNo",
    //                         nil];
    //    NSString *xpoint = @"addOrderByPurchase.do?";
    //    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //        [self interfaceData:respond setResult:error];
    //    }];
}

// ----------------------------------------------------------------------------------------
// 购物车订单提交
// ----------------------------------------------------------------------------------------
- (void)submitCartData:(NSString *)noteStr {
    
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [Tools stringForKey:KEY_USER_ID],          @"uid",
    //                         addressView.addressID,                     @"addressId",
    //                         _submitStr,                                 @"cids",
    //                         noteStr,                                   @"messages",
    //                         @"1",                                      @"consigneeType",
    //                         paymentView.payType,                       @"payMethod",
    //                         paymentView.walletType,                    @"wallet",
    //                         paymentView.vouchersNO,                    @"couponNo",
    //                         nil];
    //    NSString *xpoint = @"addorder.do?";
    //    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //        [self interfaceData:respond setResult:error];
    //    }];
}

// ----------------------------------------------------------------------------------------
//  套餐直接购买订单提交
// ----------------------------------------------------------------------------------------
- (void)submitComboData:(NSString *)noteStr {
    
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [Tools stringForKey:KEY_USER_ID],          @"uid",
    //                         addressView.addressID,                     @"addressId",
    //                         _proId,                                     @"pkgId",
    //                         noteStr,                                   @"buyer_message",
    //                         @"1",                                      @"consigneeType",
    //                         paymentView.payType,                       @"payMethod",
    //                         paymentView.walletType,                    @"wallet",
    //                         paymentView.vouchersNO,                    @"couponNo",
    //                         nil];
    //    NSString *xpoint = @"addPkgOrderByPurchase.do?";
    //    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //        [self interfaceData:respond setResult:error];
    //    }];
}

//确认订单接口 响应数据
//- (void)interfaceData:(MailWorldRequest *)respond setResult:(NSError *)error {

//    if (error) {
//        submitView.submitButton.userInteractionEnabled = YES;
//    } else {
//
//        if (respond.result == 1) {
//
//            //漏斗-支付订单
//            [Statistical event:@"OrderPayment"];
//
//            BOOL fullpay = [[respond.respondData objectForKey:@"fullpay"]boolValue];
//
//            //钱包金额 是否满足 全额支付
//            if (fullpay) {
//
//                //漏斗-支付成功
//                [Statistical event:@"PaySuccess"];
//
//                PaySuccessViewController *allOrderView = [[PaySuccessViewController alloc]init];
//                allOrderView.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:allOrderView animated:YES];
//
//            } else {
//
//                CGFloat balanceFloat = [[respond.respondData valueForKey:@"balance"]floatValue];
//                NSString *balanceStr = [NSString stringWithFormat:@"%0.1f",balanceFloat];
//                [Tools saveObject:balanceStr forKey:User_WalletBalance];
//
//                NSDictionary *aplipay = [respond.respondData objectForKey:@"aplipay"];
//                NSDictionary *wxpay = [respond.respondData objectForKey:@"wxpay"];
//                NSDictionary *charge = [respond.respondData objectForKey:@"charge"];
//
//                AppPay *pay = [AppPay alloc];
//                if ([paymentView.payType isEqual:@"1"]) {
//                    //支付宝支付
//                    outTradeNo = [aplipay valueForKey:@"out_trade_no"];
//                    [pay initWithDicctionary:aplipay fromPay:@"Alpay" payDelegate:self];
//                }
//
//                if ([paymentView.payType isEqual:@"2"]) {
//                    //微信支付
//                    outTradeNo = [wxpay valueForKey:@"out_trade_no"];
//                    [pay initWithDicctionary:wxpay fromPay:@"Wxpay" payDelegate:self];
//                }
//
//                if ([paymentView.payType isEqual:@"5"] || [paymentView.payType isEqual:@"6"]) {
//                    //网银支付
//                    outTradeNo = [charge valueForKey:@"out_trade_no"];
//                    [pay initWithDicctionary:charge fromPay:@"UnionPay" payDelegate:self];
//                }
//            }
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCart" object:nil];          //通知购物车列表更新
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateOrderNumber" object:nil];    //通知订单数量更新
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStockOne" object:nil];      //通知秒杀库存量更新
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProductDetail" object:nil]; //通知详情购物车数量更新
//
//        } else {
//            submitView.submitButton.userInteractionEnabled = YES;
//
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示信息" message:respond.error_msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alter show];
//        }
//
//    }
//}

// ----------------------------------------------------------------------------------------
// 支付状态回调
// ----------------------------------------------------------------------------------------
- (void)callbackResult:(NSInteger)result resultTitle:(NSString *)title errorContent:(NSString *)error {
    
    //    [self queryPayStatus];
    //
    //    if (result == 0) {
    //        //漏斗-支付成功
    //        [Statistical event:@"PaySuccess"];
    //
    //        PaySuccessViewController *allOrderView = [[PaySuccessViewController alloc]init];
    //        allOrderView.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:allOrderView animated:YES];
    //    } else {
    //        PayFailureViewController *payFailureView = [[PayFailureViewController alloc]init];
    //        payFailureView.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:payFailureView animated:YES];
    //    }
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateOrderNumber" object:nil];    //通知订单数量更新
}

// ----------------------------------------------------------------------------------------
// 支付状态同步处理
// ----------------------------------------------------------------------------------------
- (void)queryPayStatus {
    
    //    [AppPay queryPayStatus:outTradeNo setPayMethod:paymentView.payType];
}

#pragma mark - 数据源-代理

// ----------------------------------------------------------------------------------------
// 设置 cell 行高
// ----------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

// ----------------------------------------------------------------------------------------
// 设置分区数量
// ----------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_data count];
}

// ----------------------------------------------------------------------------------------
// 设置每个分区的 cell 行数
// ----------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ConfirmOrderEntity *entity = [_data objectAtIndex:section];
    return [entity.products count];
}

// ----------------------------------------------------------------------------------------
// 设置 cell 展示内容
// ----------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ConfirmOrderCell";
    ConfirmOrderCell *cell = (ConfirmOrderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConfirmOrderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([_data count] > 0) {
        
        ConfirmOrderEntity *entity = [_data objectAtIndex:[indexPath section]];
        NSArray *products = [entity.products objectAtIndex:[indexPath row]];
        
        //图片
        [cell.imageName sd_setImageWithURL:[NSURL URLWithString:[products valueForKey:@"good_image"]] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRetryFailed];
        [cell.imageName.layer setBorderColor:[LINECOLOR_DEFAULT CGColor]];
        [cell.imageName.layer setBorderWidth:0.5];
        
        //标题
        cell.name.text = [products valueForKey:@"good_name"];
        cell.name.font = [UIFont fontWithName:FontName_Default size:12];
        
        CGSize nameSize = [cell.name.text sizeWithFont:cell.name.font constrainedToSize:CGSizeMake(ScreenWidth-viewRight(cell.imageName)-80,50) lineBreakMode:NSLineBreakByWordWrapping];
        cell.name.frame = CGRectMake(viewRight(cell.imageName)+8, ViewY(cell.name), nameSize.width, nameSize.height);
        
        //单价
        cell.price.text = [NSString stringWithFormat:@"¥ %@",[products valueForKey:@"good_price"]];
        //        cell.price.font = [UIFont fontWithName:FontName_Default size:12];
        //        [cell.price setFrame:CGRectMake(ScreenWidth-80, ViewY(cell.name), 60, 20)];
        
        //数量
        cell.itemNum.text = [NSString stringWithFormat:@"%@件",[products valueForKey:@"nums"]];
        //        cell.itemNum.font = [UIFont fontWithName:FontName_Default size:11];
        //        [cell.itemNum setFrame:CGRectMake(ScreenWidth-80, viewBottom(cell.price), 60, 14)];
        
        //sku信息
        //        cell.attribute.text = [products valueForKey:@"skuValue"];
        //        cell.attribute.font = [UIFont fontWithName:FontName_Default size:12];
        //        [cell.attribute setFrame:CGRectMake(viewRight(cell.imageName)+8, viewBottom(cell.imageName)-12, 200, 12)];
        //
        //        if ([[products valueForKey:@"skuValue"] isEqualToString:@""]) {
        //            cell.attribute.hidden = YES;
        //        } else {
        //            cell.attribute.hidden = NO;
        //        }
        
        
    }
    return cell;
}

// ----------------------------------------------------------------------------------------
// Cell的响应事件
// ----------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    //    ConfirmOrderEntity *entity = [_data objectAtIndex:[indexPath section]];
    //    NSArray *products = [entity.products objectAtIndex:[indexPath row]];
    //
    //    ProductDetailsViewController *detailView = [[ProductDetailsViewController alloc]init];
    //    detailView.hidesBottomBarWhenPushed = YES;
    //    detailView.proId = [products valueForKey:@"productId"];
    //    detailView.activityId = [NSString stringWithFormat:@"%@",[products valueForKey:@"activityId"]];
    //    detailView.title = @"商品详情";
    //    [self.navigationController pushViewController:detailView animated:YES];
    
}

#pragma mark TableViewCell 分组 headerView footerView

// ----------------------------------------------------------------------------------------
// 设置分区 Header 展示内容
// ----------------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ConfirmOrderEntity *entity = [_data objectAtIndex:section];
    
    ConfirmSectionHeaderView *sectionHeaderView = [[ConfirmSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableViewSectionHeaderHeight)];
    sectionHeaderView.title.text = entity.shopName;
    sectionHeaderView.button.tag = section;
    return sectionHeaderView;
}

// ----------------------------------------------------------------------------------------
// 设置分区 Footer 展示内容
// ----------------------------------------------------------------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    ConfirmOrderEntity *entity = [_data objectAtIndex:section];
    
    ConfirmSectionFooterView *sectionFooterView = [[ConfirmSectionFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableViewSectionFooterHeight)];
        sectionFooterView.price = @"123";
        sectionFooterView.number = @"124";
        sectionFooterView.preferential = @"125";
        sectionFooterView.textField.delegate = self;
        sectionFooterView.textField.tag = section;
        sectionFooterView.textField.text = entity.note;
        [sectionFooterView reloadDisplayData];
    
    return sectionFooterView;
}

#pragma mark - UITextField 相关操作

// ----------------------------------------------------------------------------------------
// 文本框失去first responder 时，执行
// ----------------------------------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //    ConfirmOrderEntity *entity = [_data objectAtIndex:textField.tag];
    //    entity.note = textField.text;
}

// ----------------------------------------------------------------------------------------
// 键盘上的 return
// ----------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// ----------------------------------------------------------------------------------------
// 输入时监测
// ----------------------------------------------------------------------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= 45) {
        return NO; // return NO to not change text
    }
    return YES;
}

#pragma mark - PaymentModuleView

- (void)paymentModuleView:(PaymentModuleView *)paymentModuleView heightForView:(CGFloat)height {
    [tableHeaderView setFrame:CGRectMake(0, 0, ScreenWidth, viewBottom(paymentView)+10)];
    [self.tableView setTableHeaderView:tableHeaderView];
}

@end