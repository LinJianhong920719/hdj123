//
//  MyCartViewController.m
//  购物车
//
//  Created by lixinfan on 15-03-01.
//  Copyright (c) 2015年 taozhuma. All rights reserved.
//

#import "MyCartViewController.h"
#import "CartCell.h"
#import "CartEntity.h"
#import "CartStoreEntity.h"
#import "CartProductEntity.h"
//#import "ProductDetailsViewController.h"
//#import "ConfirmOrderViewController.h"
#import "UIImageView+WebCache.h"
//#import "SearchListViewController.h"
//#import "WaitingOrderViewController.h"
//#import "ActivitiesDetailsViewController.h"
//#import "RCIM_CustomerServiceViewController.h"

//#define UmengEventID @"MyCartViewController"

@interface MyCartViewController () {
    BOOL GTTabBar_Current;      //GTTabBar是否当前选中的
    
    UIView *settlementView;
    UIButton *btnDetermine;
    UILabel *labelCount;
    UILabel *labelPreferential;
    UIImageView *iconRMB;
    UILabel *subtotalLabel;
    UIButton *checkAllButton;
    UIButton *rightBtn;
    UIView *emptyView;
    NSMutableArray *sectionArray;
    UIButton *delBtn;
    
}

@end

@implementation MyCartViewController
@synthesize ptagid;
@synthesize comeTag;

#pragma mark - UI

- (void)loadView {
    [super loadView];
    [self loadData];
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 32)];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 65)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewOrignY-viewBottom(headerView), DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY+viewBottom(headerView)+20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_eeefef;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 43, 0, 15);
    _tableView.separatorColor = COLOR_eeefef;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(viewBottom(headerView), 0, viewBottom(footerView), 0);
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = headerView;
    [footerView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableFooterView = footerView;
    
    //结算
    settlementView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT-95, DEVICE_SCREEN_SIZE_WIDTH, 45)];
    settlementView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:settlementView];
    //    settlementView.hidden=YES;
    
    UILabel *selectAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 0, 250, 45)];
    selectAllLabel.textColor = UIColorWithRGBA(62, 58, 57, 1);
    selectAllLabel.font = [UIFont boldSystemFontOfSize:13];
    selectAllLabel.text = @"全选";
    [settlementView addSubview:selectAllLabel];
    
    //定义全选按钮
    checkAllButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 43, 45)];
    [checkAllButton setImageEdgeInsets:UIEdgeInsetsMake(13.0, 12.0, 14.0, 13.0)];
    [checkAllButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [checkAllButton addTarget:self action:@selector(selectedAll) forControlEvents:UIControlEventTouchUpInside];
    [settlementView addSubview:checkAllButton];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,DEVICE_SCREEN_SIZE_WIDTH, 0.5)];
    [line1 setBackgroundColor:LINECOLOR_DEFAULT];
    [settlementView addSubview:line1];
    //结算按钮
    btnDetermine = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDetermine setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-80, 0, 80, 45)];
    [btnDetermine setBackgroundColor:UIColorWithRGBA(255, 80, 0, 1)];
    [btnDetermine setTitle:[NSString stringWithFormat:@"结算"]forState:UIControlStateNormal];
    [btnDetermine.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    //    btnDetermine.layer.cornerRadius = 2;
    [btnDetermine addTarget:self action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
    [settlementView addSubview:btnDetermine];
    
    //删除按钮
    delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-80, 0, 80, 45)];
    [delBtn setBackgroundColor:UIColorWithRGBA(255, 80, 0, 1)];
    [delBtn setTitle:[NSString stringWithFormat:@"删除"]forState:UIControlStateNormal];
    [delBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    //    btnDetermine.layer.cornerRadius = 2;
    [delBtn addTarget:self action:@selector(delCellClick:) forControlEvents:UIControlEventTouchUpInside];
    [settlementView addSubview:delBtn];
    delBtn.hidden = YES;
    
    // 结算金额
    labelCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btnDetermine.frame.origin.x-16, 30)];
    labelCount.textAlignment = NSTextAlignmentRight;
    labelCount.textColor = UIColorWithRGBA(255, 80, 0, 1);
    labelCount.font = [UIFont fontWithName:FontName_Default size:12];
    [settlementView addSubview:labelCount];
    
    // 节省金额
    labelPreferential = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, btnDetermine.frame.origin.x-16, 30)];
    labelPreferential.textAlignment = NSTextAlignmentRight;
    labelPreferential.textColor = COLOR_898989;
    labelPreferential.font = [UIFont fontWithName:FontName_Default size:11];
    [settlementView addSubview:labelPreferential];
    
    [self totalLocation];
    
    if (comeTag == 1) {
        [settlementView setFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT - 45, DEVICE_SCREEN_SIZE_WIDTH, 45)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 45, 0);
    } else {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 95, 0);
    }
    
    [self setupHeader];
    //    [self networkView];
    [self emptyView];
}


- (void)setupHeader {
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadData];
            [weakRefreshHeader endRefreshing];
        });
    };
}
/** 调整总计长度 */

- (void)totalLocation {
    
    CGSize countSize = [labelCount.text sizeWithFont:labelCount.font constrainedToSize:CGSizeMake(MAXFLOAT, 45)];
    [labelCount setFrame:CGRectMake(btnDetermine.frame.origin.x-16-countSize.width, 0, countSize.width, 25)];
    
    [iconRMB setFrame:CGRectMake(labelCount.frame.origin.x-11, 18, 7, 9)];
    
    CGSize subLabelSize = [subtotalLabel.text sizeWithFont:subtotalLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    [subtotalLabel setFrame:CGRectMake(iconRMB.frame.origin.x-subLabelSize.width-6, 0, subLabelSize.width, 25)];
    
    
    [labelCount setFrame:CGRectMake(0, 0, btnDetermine.frame.origin.x-16, 25)];
    
    labelCount.text = @"合计：¥0.0";
    labelPreferential.text = @"为你节省：¥0.0";
    labelPreferential.text = @"不含运费";
}
//删除按钮方法
- (IBAction)delCellClick:(id)sender {
    for (int i = 0; i < proData.count; i++) {
        
        CartProductEntity *entity = [proData objectAtIndex:i];
        if ([entity.chooseTag isEqualToString:@"1"]) {
            
            NSLog(@"entity.cid:%@",entity.cid);
            //删除购物车
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 entity.cid,@"cartId",
                                 nil];
            
            NSString *path = [NSString stringWithFormat:@"/Api/Cart/delCart?"];
            
            [HYBNetworking updateBaseUrl:SERVICE_URL];
            [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
                
                NSDictionary *dic = response;
                NSLog(@"response:%@",response);
                NSString *statusMsg = [dic valueForKey:@"status"];
                if([statusMsg intValue] == 4001){
                    //弹框提示获取失败
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"删除失败!";
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
                    [self showHUDText:@"删除失败!"];
                }else{
                    
                    [self loadData];
                    [_tableView reloadData];
                    
                }
                
            } fail:^(NSError *error) {
                
            }];
            
        }
        
    }
    
}
//结算按钮方法
- (IBAction)determineClick:(id)sender {
    
    //确定提交购物车
    NSMutableArray *submitArray = [[NSMutableArray alloc]init];
    [submitArray removeAllObjects];
    
    //修改购物车数量
    NSMutableArray *modifyArray = [[NSMutableArray alloc]init];
    [modifyArray removeAllObjects];
    
    NSString *submitStr;
    NSString *modifyStr;
    
    for (int i = 0; i < proData.count; i++) {
        
        CartProductEntity *entity = [proData objectAtIndex:i];
        if ([entity.chooseTag isEqualToString:@"1"] && [entity.status integerValue] == 1&&[entity.isActive integerValue] != 2) {
            
            NSString *str = [NSString stringWithFormat:@"%@:%@",entity.cid,entity.number];
            [modifyArray addObject:str];
            [submitArray addObject:entity.cid];
        }
        modifyStr = [modifyArray componentsJoinedByString:@","];
        submitStr = [submitArray componentsJoinedByString:@","];
    }
    
    btnDetermine.userInteractionEnabled = NO;
    if (submitStr.length > 0) {
        
        //执行修改
        //        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
        //                             [Tools stringForKey:KEY_USER_ID],           @"uid",
        //                             modifyStr,              @"cids",
        //                             nil];
        //        NSString *xpoint = @"toEditCart.do?";
        //        [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
        //            if (error) {
        //                btnDetermine.userInteractionEnabled = YES;
        //            } else {
        //
        //                if(respond.result == 1) {
        //                    btnDetermine.userInteractionEnabled = YES;
        //                    //跳转到确认订单页
        //                    ConfirmOrderViewController *confirmOrder = [[ConfirmOrderViewController alloc] init];
        //                    confirmOrder.title = @"确认订单";
        //                    confirmOrder.from = 2;
        //                    confirmOrder.submitStr = submitStr;
        //                    confirmOrder.hidesBottomBarWhenPushed = YES;
        //                    [self.navigationController pushViewController:confirmOrder animated:YES];
        //                }else{
        //                    btnDetermine.userInteractionEnabled = YES;
        //                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //                    hud.mode = MBProgressHUDModeText;
        //                    hud.labelText = respond.error_msg;
        //                    hud.yOffset = -50.f;
        //                    hud.removeFromSuperViewOnHide = YES;
        //                    [hud hide:YES afterDelay:2];
        //
        //                }
        //
        //            }
        //        }];
        //
        //    } else {
        //        btnDetermine.userInteractionEnabled = YES;
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.mode = MBProgressHUDModeText;
        //        hud.detailsLabelText = @"请选择商品";
        //        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
        //        hud.removeFromSuperViewOnHide = YES;
        //        [hud hide:YES afterDelay:2];
    }
    
}

/** 调没有商品时显示 */

- (void)emptyView {
    
    settlementView.hidden = YES;
    
    emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewOrignY, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY)];
    emptyView.hidden = YES;
    [emptyView setBackgroundColor:BGCOLOR_DEFAULT];
    [self.view addSubview:emptyView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_null"]];
    imageView.frame = CGRectMake((DEVICE_SCREEN_SIZE_WIDTH - 119)/2, (DEVICE_SCREEN_SIZE_HEIGHT - 350)/2, 119, 119);
    [emptyView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.frame.size.height + imageView.frame.origin.y + 20, DEVICE_SCREEN_SIZE_WIDTH-20, 20)];
    label.textColor = FONTS_COLOR;
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您还没有购买任何商品~！";
    //    if([[Tools stringForKey:KEY_USER_TYPE]integerValue] == 6 || [Tools boolForKey:KEY_IS_LOGIN] != YES ){
    //        label.text = @"购物车空空如也";
    //    }else{
    //        label.text = @"您的购物车还是空的，添加点商品吧！";
    //    }
    [emptyView addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 145)/2, viewBottom(label)+25, 145, 35)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitle:@"去逛逛" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [btn setTitleColor:FONTS_COLOR102 forState:UIControlStateNormal];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 3;
    btn.layer.borderColor = [FONTS_COLOR102 CGColor];
    [btn addTarget:self action:@selector(mailhome:) forControlEvents:UIControlEventTouchUpInside];
    [emptyView addSubview:btn];
}

- (IBAction)mailhome:(id)sender {
    //通知 发出
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refSelectedIndex" object:nil];
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    if ([Tools intForKey:KEY_TabBarNum] == 3) {
    //        //页面统计-开始
    //        [Statistical beginLogPageView:UmengEventID];
    //    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //    if ([Tools intForKey:KEY_TabBarNum] == 3) {
    //        //页面统计-结束
    //        [Statistical endLogPageView:UmengEventID];
    //    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (comeTag == 1) {
        //显示导航栏左侧按钮
        //        [self hideNaviBarLeftBtn:NO];
    } else {
        //隐藏导航栏左侧按钮
        [self hideNaviBarLeftBtn:YES];
    }
    
    //导航栏右侧按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorWithRGBA(255, 80, 0, 1) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
    rightBtn.hidden = NO;
    [rightBtn addTarget:self action:@selector(editorClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setNaviBarRightBtn:rightBtn];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameWillChange:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCart:) name:@"changeCartNum"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCart:) name:@"chooseCartNum"object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartSub:) name:@"cartSubtotal"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refCart:) name:@"refreshCart"object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeGTTabBarIndex:) name:GTTabBarIndex_Change object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openActView:) name:OpenActivitiesShowView object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCustomerServiceView:) name:OpenCustomerService object:nil];
    
    GTTabBar_Current = YES;
    
    //初始化data
    stoData = [[NSMutableArray alloc]init];
    proData = [[NSMutableArray alloc]init];
    
    sectionArray = [[NSMutableArray alloc]init];
    
    //    [self loadData];
    
}

#pragma mark - NSNotification

// ----------------------------------------------------------------------------------------
// StatusBarFrame变更通知
// ----------------------------------------------------------------------------------------
- (void)statusBarFrameWillChange:(NSNotification*)notification {
    _tableView.frame =CGRectMake(0, ViewOrignY-32, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY+32+20);
    if (comeTag == 1) {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 45, 0);
        [settlementView setFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT - 45, DEVICE_SCREEN_SIZE_WIDTH, 45)];
        self.navigationController.hidesBottomBarWhenPushed=YES;
    } else {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 95, 0);
        [settlementView setFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT - 95, DEVICE_SCREEN_SIZE_WIDTH, 45)];
    }
}

// ------------------------------------------------------------------------------------------
// 展开活动详情通知
// ------------------------------------------------------------------------------------------
//- (void)openActView:(NSNotification*)notification {
//
//    //是否是当前正在显示
//    if ([Tools intForKey:KEY_TabBarNum] == 3) {
//
//        NSDictionary *info = [notification object];
//
//        NSString *title = [NSString stringWithFormat:@"%@",[info valueForKey:@"title"]];
//        NSString *webLink = [NSString stringWithFormat:@"%@",[info valueForKey:@"webLink"]];
//
//        ActivitiesDetailsViewController *activitiesDetailsView = [[ActivitiesDetailsViewController alloc]init];
//        activitiesDetailsView.title = title;
//        activitiesDetailsView.linkDddress = webLink;
//        activitiesDetailsView.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:activitiesDetailsView animated:YES];
//    }
//}

// ----------------------------------------------------------------------------------------
// GTTabBar菜单项变更通知
// ----------------------------------------------------------------------------------------
//- (void)changeGTTabBarIndex:(NSNotification*)notification {
//
//    if ([Tools intForKey:KEY_TabBarNum] == 3) {
//
//        if (!GTTabBar_Current) {
//            //页面统计-开始
//            [Statistical beginLogPageView:UmengEventID];
//            //计数统计
//            [Statistical event:UmengEventID];
//        }
//
//        GTTabBar_Current = YES;
//    } else {
//        //页面统计-结束
//        [Statistical endLogPageView:UmengEventID];
//
//        GTTabBar_Current = NO;
//    }
//    _tableView.scrollsToTop = GTTabBar_Current;
//}

// ------------------------------------------------------------------------------------------
// 展开客服会话页
// ------------------------------------------------------------------------------------------
//- (void)openCustomerServiceView:(NSNotification*)notification {
//
//    //是否是当前正在显示
//    if ([Tools intForKey:KEY_TabBarNum] == 3) {
//        if (![self.navigationController.topViewController isKindOfClass:[RCIM_CustomerServiceViewController class]]) {
//            RCIM_CustomerServiceViewController *customerService = [[RCIM_CustomerServiceViewController alloc]init];
//            customerService.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:customerService animated:YES];
//        }
//    }
//}

/** 点击编辑 */
- (IBAction)editorClick:(id)sender {
    NSArray *cellArray = [_tableView visibleCells];
    //是否为编辑中：勾选图标显示
    if ([rightBtn.titleLabel.text isEqual:@"编辑"]) {
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rightBtn setTitleColor:THEME_COLORS_RED forState:UIControlStateNormal];
        [self setHiddens:YES];
        
        
    } else {
        [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [rightBtn setTitleColor:FONT_COLOR forState:UIControlStateNormal];
        [self setHiddens:NO];
        
    }
}

//编辑控制"结算"与"删除"按钮方法
- (void)setHiddens:(BOOL)hidden {
    if (hidden) {
        delBtn.hidden = NO;
        btnDetermine.hidden = YES;
    } else {
        delBtn.hidden = YES;
        btnDetermine.hidden = NO;
    }
}

/** 接收刷新通知 */
- (void) refCart:(NSNotification*) notification {
    [stoData removeAllObjects];
    [proData removeAllObjects];
    [self loadData];
    
    [self totalLocation];
}

/** 接收每个cell修改后的商品 数目 */
- (void) changeCart:(NSNotification*) notification {
    //接收数组
    NSMutableArray *obj = [notification object];
    for (int i = 0; i < proData.count; i++) {
        CartProductEntity *entity = [proData objectAtIndex:i];
        if ([entity.cid isEqualToString:[obj objectAtIndex:0]]) {
            entity.number = [obj objectAtIndex:1];
        }
    }
}

/** 接收每个cell修改后的商品 价格小计 */

- (void) cartSub:(NSNotification*) notification {
    //接收数组
    NSMutableArray *obj = [notification object];
    
    
    for (int i = 0; i < proData.count; i++) {
        CartProductEntity *entity = [proData objectAtIndex:i];
        if ([entity.cid isEqualToString:[obj objectAtIndex:0]]) {
            entity.subtotal = [obj objectAtIndex:1];
        }
    }
    [self totalPriceAndNum];
}

/** 修改选中状态 */

- (void) chooseCart:(NSNotification*) notification {
    //接收数组
    NSMutableArray *obj = [notification object];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSString *shopId = [obj objectAtIndex:1];
    NSString *chooseTag = [obj objectAtIndex:2];
    
    for (int i = 0; i < proData.count; i++) {
        CartProductEntity *entity = [proData objectAtIndex:i];
        if ([entity.cid isEqualToString:[obj objectAtIndex:0]]) {
            entity.chooseTag = chooseTag;
            if ([entity.shopId isEqual:shopId]) {
                [array addObject:entity.chooseTag];
            }
        }
        
        
    }
    
    if ([array containsObject:@"0"]) {
        [self changeStore:[shopId integerValue] setChooseTag:@"0"];
    } else {
        [self changeStore:[shopId integerValue] setChooseTag:@"1"];
    }
    
    [self totalPriceAndNum];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (buttonIndex == 1)  {
//
//        CartProductEntity *entity = [proData objectAtIndex:alertView.tag];
//        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                             [Tools stringForKey:KEY_USER_ID],               @"uid",
//                             entity.cid,           @"cids",
//                             nil];
//        NSString *xpoint = @"delCart.do?";
//        [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//            if (error) {
//            } else {
//
//                if (respond.result == 1) {
//                    //删除成功后刷新数据与执行刷新购物车数量通知
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNum" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCart" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProductDetail" object:nil];
//                }
//            }
//        }];
//
//    }
//}

- (IBAction)newloadDataClick:(id)sender {
    [stoData removeAllObjects];
    [proData removeAllObjects];
    [_tableView reloadData];
    //    [self loadData];
}


#pragma mark 加载数据

- (void)loadData {
    
    NSLog(@"userId:%@",[Tools stringForKey:KEY_USER_ID]);
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"/Api/Cart/show?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSLog(@"response:%@",response);
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
        }if([statusMsg intValue] == 201){
            settlementView.hidden = YES;
            rightBtn.hidden = YES;
            emptyView.hidden = NO;
//            //弹框提示获取失败
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
////            hud.labelText = @"无数据";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
            return;
        }if([statusMsg intValue] == 4002){
            [self showHUDText:@"获取失败!"];
        }else{
            
            settlementView.hidden = NO;
            rightBtn.hidden = NO;
            emptyView.hidden = YES;
            
            NSInteger row = 0;
            NSInteger section = 0;
            
            [stoData removeAllObjects];
            [proData removeAllObjects];
            
            [sectionArray removeAllObjects];
            if([[dic valueForKey:@"data"] count] > 0 && [dic valueForKey:@"data"] != nil){
                NSLog(@"data:%@",[dic valueForKey:@"data"]);
                for (NSDictionary *temList in [dic valueForKey:@"data"]){
                    CartStoreEntity *entity = [[CartStoreEntity alloc]initWithAttributes:temList];
                    [stoData addObject:entity];
                    NSMutableArray *rowArray = [[NSMutableArray alloc]init];
                    for (NSDictionary *proDic in entity.carts) {
                        CartProductEntity *entitys = [[CartProductEntity alloc]initWithAttributes:proDic];
                        [proData addObject:entitys];
                        [rowArray addObject:[NSString stringWithFormat:@"%ld",(long)row]];
                        
                        row ++;
                    }
                    [sectionArray addObject:rowArray];
                    section ++;
                    
                }
                [_tableView reloadData];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"无数据";
                hud.yOffset = -50.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

#pragma mark - 数据源-代理
//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [stoData count];
    
}

//指定每个分区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CartStoreEntity *entity = [stoData objectAtIndex:section];
    return [entity.carts count];
    
}

//设置每行调用的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CartCell";
    CartCell *cell = (CartCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *rowArray = [sectionArray objectAtIndex:[indexPath section]];
    NSInteger row = [[rowArray objectAtIndex:[indexPath row]]integerValue];
    if ([stoData count] > 0) {
        
        CartProductEntity *entity = [proData objectAtIndex:row];
        
        cell.cid = entity.cid;
        cell.productId = entity.productId;
        cell.shopId = entity.shopId;
        cell.transparent.hidden = YES;
        cell.num = entity.number;
        
        if ([Tools isBlankString:entity.image]) {
            cell.imagesView.image = [UIImage imageNamed:@"default"];
        } else {
            [cell.imagesView sd_setImageWithURL:[NSURL URLWithString:entity.image] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRetryFailed];
        }
        
        cell.imagesView.layer.borderWidth = 0.5;
        cell.imagesView.layer.borderColor = [UIColorWithRGBA(180, 180, 180, 1)CGColor];
        
        cell.number.text = entity.number;
        cell.number.layer.borderWidth = 0.5;
        cell.number.layer.borderColor = [UIColorWithRGBA(180, 180, 180, 1)CGColor];
        
        cell.title.text = entity.name;
        [cell.title setNumberOfLines:2];
        cell.title.font =[UIFont systemFontOfSize:12];
        CGSize nameSize = [cell.title.text sizeWithFont:cell.title.font constrainedToSize:CGSizeMake(DEVICE_SCREEN_SIZE_WIDTH-viewRight(cell.imagesView)-55,100) lineBreakMode:NSLineBreakByWordWrapping];
        
        if((long)nameSize.height>20){
            cell.title.frame = CGRectMake(viewRight(cell.imagesView)+8, 0, nameSize.width, 50);
        }else{
            cell.title.frame = CGRectMake(viewRight(cell.imagesView)+8, 0, nameSize.width, 32);
        }
        
        
        //        cell.choose.hidden = NO;
        cell.price.text = [NSString stringWithFormat:@"¥%@", entity.price];
        
        cell.priceFloat = [entity.price floatValue];
        cell.inventory = @"9999";
        
        cell.chooseTag = entity.chooseTag;
        
        
        //是否为编辑状态
        if ([rightBtn.titleLabel.text isEqual:@"编辑"]) {
            [cell setHidden:YES];
            
        } else {
            [cell setHidden:NO];
            
        }
        
        cell.delBtn.tag = row;
        [cell.delBtn addTarget:self action:@selector(delCartClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.delBtn setFrame:CGRectMake( DEVICE_SCREEN_SIZE_WIDTH-40, cell.activityType.frame.origin.y-10, 40, 40)];
        [cell.delBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        UIImage *chooseImage;
        if ([cell.chooseTag integerValue] == 1) {
            chooseImage = [UIImage imageNamed:@"checkbox_active.png"];
            [cell setChecked:YES];
        } else {
            chooseImage = [UIImage imageNamed:@"checkbox.png"];
            [cell setChecked:NO];
        }
        [cell.choose setImage:chooseImage forState:UIControlStateNormal];
    }
    
    return cell;
}

//设置选中Cell的响应事件
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSArray *rowArray = [sectionArray objectAtIndex:[indexPath section]];
//    NSInteger row = [[rowArray objectAtIndex:[indexPath row]]integerValue];
//
//    CartProductEntity *entity = [proData objectAtIndex:row];
//
//    ProductDetailsViewController * detailView = [[ProductDetailsViewController alloc]init];
//    detailView.hidesBottomBarWhenPushed = YES;
//    detailView.proId = entity.productId;
//    detailView.activityId =[NSString stringWithFormat:@"%@",entity.activityId];;
//    detailView.title = @"商品详情";
//    [self.navigationController pushViewController:detailView animated:YES];
//
//}

#pragma mark TableViewCell 分组 headerView footerView

// section 头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CartStoreEntity *entity = [stoData objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 32)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.tag = section;
    
    EMAsyncImageView *line = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(43, viewBottom(view)-1,DEVICE_SCREEN_SIZE_WIDTH-58, 1)];
    [line setBackgroundColor:COLOR_eeefef];
    [view addSubview:line];
    
    UILabel *selectAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 0, 250, 32)];
    selectAllLabel.textColor = UIColorWithRGBA(159, 160, 160, 1);
    selectAllLabel.font = [UIFont boldSystemFontOfSize:13];
    selectAllLabel.text = entity.shopName;
    selectAllLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:selectAllLabel];
    
    CGSize arrowSize = CGSizeMake(7, 11);
    //        CGSize selectAllSize = [selectAllLabel.text sizeWithFont:selectAllLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 32)];
    EMAsyncImageView *arrow = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-23, (view.frame.size.height-arrowSize.height)/2, arrowSize.width, arrowSize.height)];
    [arrow setImage:[UIImage imageNamed:@"address_go.png"]];
    [view addSubview:arrow];
    
    
    //定义商家全选按钮
    UIButton *shopSelectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 43, 32)];
    [shopSelectButton setImageEdgeInsets:UIEdgeInsetsMake(7.0, 12.0, 7.0, 13.0)];
    [shopSelectButton setTag:[entity.shopId integerValue]];
    [shopSelectButton addTarget:self action:@selector(selectedStore:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shopSelectButton];
    [shopSelectButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    
    if ([entity.chooseTag integerValue] == 0) {
        [shopSelectButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    } else {
        [shopSelectButton setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal];
    }
    
    return view;
}

// section 底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    CartStoreEntity *entity = [stoData objectAtIndex:section];
    //    //通过discountType判断是否存在满减或者满折显示tableView高度
    //    if (entity.discountType > 0) {
    //        return 41+20.0;
    //    }else{
    //        return 41;
    //    }
    return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CartStoreEntity *entity = [stoData objectAtIndex:section];
    
    CGFloat discountHeight;
    //    if (entity.discountType > 0) {
    //        discountHeight = 20.0;
    //    }else{
    //        discountHeight = 00.0;
    //    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 41+discountHeight)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 32+discountHeight)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:bgView];
    
    EMAsyncImageView *line = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(43, 0, DEVICE_SCREEN_SIZE_WIDTH-58, 1)];
    [line setBackgroundColor:COLOR_eeefef];
    [bgView addSubview:line];
    
    
    //    entity.preferential = 0.0;
    
    // -------------------- 小计 --------------------
    
    UILabel *subtotalPrice = [[UILabel alloc]init];
    [subtotalPrice setTextAlignment:NSTextAlignmentRight];
    [subtotalPrice setTextColor:THEME_COLORS_RED];
    [subtotalPrice setFont:[UIFont systemFontOfSize:16]];
    //    [subtotalPrice setText:[NSString stringWithFormat:@"%@",entity.discountPrice]];
    [view addSubview:subtotalPrice];
    
    UILabel *subtotalNum = [[UILabel alloc]init];
    [subtotalNum setTextColor:COLOR_898989];
    [subtotalNum setFont:[UIFont systemFontOfSize:12]];
    //    [subtotalNum setText:[NSString stringWithFormat:@"小计(共%@件):",entity.subNumber]];
    [view addSubview:subtotalNum];
    
    
    // -------------------- 满减 --------------------
    
    CGSize discountStyleSize = CGSizeMake(13, 13);
    
    UILabel *discountStyle = [[UILabel alloc]initWithFrame:CGRectMake(8, (discountHeight-discountStyleSize.height)/2+5, discountStyleSize.width, discountStyleSize.height)];
    discountStyle.textColor = [UIColor whiteColor];
    discountStyle.font = [UIFont fontWithName:FontName_Default_Bold size:9];
    discountStyle.textAlignment = NSTextAlignmentCenter;
    discountStyle.layer.masksToBounds = YES;
    discountStyle.layer.cornerRadius = 2;
    [bgView addSubview:discountStyle];
    
    UILabel *discountText = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(discountStyle)+6, 5, ViewWidth(bgView)-viewRight(discountStyle), discountHeight)];
    discountText.textColor = COLOR_474647;
    discountText.font = [UIFont fontWithName:FontName_Default size:12];
    [bgView addSubview:discountText];
    
    UILabel *thresholdLabel = [[UILabel alloc]init];
    thresholdLabel.textColor = COLOR_898989;
    thresholdLabel.font = [UIFont fontWithName:FontName_Default size:12];
    thresholdLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:thresholdLabel];
    
    UILabel *preferentialLabel = [[UILabel alloc]init];
    preferentialLabel.textColor = COLOR_474647;
    preferentialLabel.font = [UIFont fontWithName:FontName_Default size:11];
    preferentialLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:preferentialLabel];
    
    
    //    switch (entity.discountType) {
    //        case 1: {
    //            discountStyle.text = @"减";
    //            discountStyle.backgroundColor = COLOR_46D232;
    //            discountStyle.hidden = NO;
    //            discountText.hidden = NO;
    //        }   break;
    //        case 2: {
    //            discountStyle.text = @"折";
    //            discountStyle.backgroundColor = THEME_COLORS_RED;
    //            discountStyle.hidden = NO;
    //            discountText.hidden = NO;
    //        }   break;
    //        default: {
    //            discountStyle.hidden = YES;
    //            discountText.hidden = YES;
    //        }   break;
    //    }
    
    
    //    CGFloat subPrice = [entity.subPrice floatValue];       //小计金额
    //    NSInteger subNumber = [entity.subNumber integerValue];  //小计数量
    
    discountText.hidden = NO;
    discountStyle.hidden = NO;
    
    //    switch (entity.discountType) {
    //        case 1: {
    //            CGFloat needToPrice;        //需要达到的数值
    //            CGFloat preferential;       //达成后减免的金额
    //
    //            for (NSDictionary *dic in entity.discountArray) {
    //
    //                needToPrice =  [[dic valueForKey:@"om"]floatValue];
    //                preferential = [[dic valueForKey:@"m"]floatValue];
    //
    //                //                NSLog(@"subPrice:%0.1f preferential:%0.1f needToPrice:%0.1f",subPrice,preferential,needToPrice);
    //                if (subPrice >= needToPrice) {
    //                    thresholdLabel.text = [NSString stringWithFormat:@"满减(满%0.0f)",needToPrice];
    //                    preferentialLabel.text = [NSString stringWithFormat:@"-%0.1f",preferential];
    //                } else {
    //                    discountText.text = [NSString stringWithFormat:@"再凑%0.1f可减%0.1f",needToPrice-subPrice,preferential];
    //                    break;
    //                }
    //
    //            }
    //        }   break;
    //        case 2: {
    //            NSInteger needToNumber;     //需要达到的数值
    //            CGFloat discount;           //达成后减免的折扣
    //
    //            for (NSDictionary *dic in entity.discountArray) {
    //                needToNumber =  [[dic valueForKey:@"om"]integerValue];
    //                discount = [[dic valueForKey:@"m"]floatValue];
    //
    //                if (subNumber >= needToNumber) {
    //                    thresholdLabel.text = [NSString stringWithFormat:@"满折(满%ld件)",(long)needToNumber];
    //                    preferentialLabel.text = [NSString stringWithFormat:@"打%0.1f折",discount];
    //                } else {
    //                    discountText.text = [NSString stringWithFormat:@"再凑%ld件可%0.1f折",(long)(needToNumber-subNumber),discount];
    //                    break;
    //                }
    //
    //            }
    //        }   break;
    //    }
    
    //    if (entity.preferential > 0) {
    //        thresholdLabel.hidden = NO;
    //        preferentialLabel.hidden = NO;
    //    }
    
    if (discountText.text.length) {
        discountStyle.hidden = NO;
    } else {
        discountStyle.hidden = YES;
    }
    
    CGSize subPriceSize = [subtotalPrice.text sizeWithFont:subtotalPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, 27)];
    [subtotalPrice setFrame:CGRectMake(view.frame.size.width-16-subPriceSize.width, 4+discountHeight, subPriceSize.width, 27)];
    
    UIImageView *iconRMB2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-rmb"]];
    [iconRMB2 setFrame:CGRectMake(subtotalPrice.frame.origin.x-10, 12+discountHeight, 9, 11)];
    [view addSubview:iconRMB2];
    
    CGSize subNumSize = [subtotalNum.text sizeWithFont:subtotalNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 29)];
    [subtotalNum setFrame:CGRectMake(iconRMB2.frame.origin.x-subNumSize.width-4, 3+discountHeight, subNumSize.width, 29)];
    
    thresholdLabel.frame = CGRectMake(ViewX(subtotalNum)-200, 5, ViewWidth(subtotalNum)+200, discountHeight);
    preferentialLabel.frame = CGRectMake(ViewX(subtotalPrice)-10, 5, ViewWidth(subtotalPrice)+10, discountHeight);
    
    return view;
}

#pragma mark TableViewCell 删除
//删除按钮的文字样式
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//继承该方法时,左右滑动会出现删除按钮(自定义按钮),点击按钮时的操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowArray = [sectionArray objectAtIndex:[indexPath section]];
    NSInteger row = [[rowArray objectAtIndex:[indexPath row]]integerValue];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要从购物车移除此件商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = row;
    [alert show];
    
}
- (void)delCartClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要从购物车移除此件商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = btn.tag;
    [alert show];
}
#pragma mark - 购物车勾选
/** 勾选商家 - 更改 单品勾选状态 */
- (void) selectedProduct:(NSInteger)storeId setChooseTag:(NSString *)choosetag {
    for (int i = 0; i < proData.count; i ++) {
        CartProductEntity *entity = [proData objectAtIndex:i];
        if ([entity.shopId integerValue] == storeId) {
            entity.chooseTag = choosetag;
        }
    }
}


/** 勾选全选 - 更改 单品勾选状态 */
- (void) selectedProduct:(NSString *)choosetag {
    for (int i = 0; i < proData.count; i ++) {
        CartProductEntity *entity = [proData objectAtIndex:i];
        entity.chooseTag = choosetag;
    }
}


/** 勾选单品 - 更改 商店勾选和全选状态 */

- (void)changeStore:(NSInteger)shopId setChooseTag:(NSString *)choosetag {
    //建立动态数组 保存所有商家的选择状态
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < stoData.count; i ++) {
        CartStoreEntity *entity = [stoData objectAtIndex:i];
        if ([entity.shopId integerValue] == shopId) {
            entity.chooseTag = choosetag;
        }
        [array addObject:entity.chooseTag];
    }
    //是否存在没选中的
    if ([array containsObject:@"0"]) {
        //是 全部改为不选
        [self changeButtonStyle:NO];
    } else {
        //否 全部改为选中
        [self changeButtonStyle:YES];
    }
    [_tableView reloadData];
}


/** 点击勾选商家 */

- (IBAction)selectedStore:(id)sender {
    UIButton *btn = (UIButton *)sender;
    //建立动态数组 保存所有商家的选择状态
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < stoData.count; i ++) {
        CartStoreEntity *entity = [stoData objectAtIndex:i];
        NSLog(@"tag:%ld",(long)btn.tag);
        NSLog(@"shopId:%@",entity.shopId);
        if ([entity.shopId integerValue] == btn.tag) {
            if ([entity.chooseTag integerValue] == 0) {
                entity.chooseTag = @"1";
            } else {
                entity.chooseTag = @"0";
            }
            [self selectedProduct:btn.tag setChooseTag:entity.chooseTag];
        }
        NSLog(@"entity.chooseTag:%@",entity.chooseTag);
        [array addObject:entity.chooseTag];
    }
    NSLog(@"array:%@",array);
    //是否存在没选中的
    if ([array containsObject:@"0"]) {
        //是 全部改为不选
        [self changeButtonStyle:NO];
    } else {
        //否 全部改为选中
        [self changeButtonStyle:YES];
    }
    [self totalPriceAndNum];
}


/** 点击全选 */

- (void) selectedAll {
    //建立动态数组 保存所有商家的选择状态
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < stoData.count; i ++) {
        CartStoreEntity *entity = [stoData objectAtIndex:i];
        [array addObject:entity.chooseTag];
    }
    //是否存在没选中的
    if ([array containsObject:@"0"]) {
        //是 全部改为选中
        for (int i = 0; i < stoData.count; i ++) {
            CartStoreEntity *entity = [stoData objectAtIndex:i];
            entity.chooseTag = @"1";
        }
        [self changeButtonStyle:YES];
        [self selectedProduct:@"1"];
    } else {
        //是 全部改为不选
        for (int i = 0; i < stoData.count; i ++) {
            CartStoreEntity *entity = [stoData objectAtIndex:i];
            entity.chooseTag = @"0";
        }
        [self changeButtonStyle:NO];
        [self selectedProduct:@"0"];
    }
    [self totalPriceAndNum];
}


/** 改变全选按钮样式 */

- (void) changeButtonStyle:(BOOL)change {
    if (change) {
        [checkAllButton setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal];
    } else {
        [checkAllButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
}

#pragma mark 统计价格/数量

- (void) totalPriceAndNum {
    [NSThread detachNewThreadSelector:@selector(totalStore) toTarget:self withObject:nil];
    [_tableView reloadData];
}

/** 同商家商品总数量 价格 */

- (void) totalStore {
    
    for (int i = 0; i < stoData.count; i ++) {
        CartStoreEntity *entity = [stoData objectAtIndex:i];
        
        NSInteger number = 0;
        float price = 0.0;
        
        for (int i = 0; i < proData.count; i ++) {
            CartProductEntity *entitys = [proData objectAtIndex:i];
            
            if ([entitys.shopId integerValue] == [entity.shopId integerValue]) {
                
                if ([entitys.chooseTag integerValue] == 1) {
                    
                    number += [entitys.number integerValue];
                    price += [entitys.price floatValue];
                }
            }
        }
        
        //        switch (entity.discountType) {
        //            case 0: {
        //                entity.preferential = 0.0;
        //            }   break;
        //            case 1: {
        //                                entity.preferential = [self storePreferentialArray:entity.discountArray totalPrice:price];
        //            }   break;
        //            case 2: {
        //                //                entity.preferential = [self storeDiscountArray:entity.discountArray totalPrice:price totalNumber:(long)number];
        //            }   break;
        //        }
        //
        //        entity.subNumber = [NSString stringWithFormat:@"%ld",(long)number];
        //        entity.subPrice = [NSString stringWithFormat:@"%0.1f",price];
        //        entity.discountPrice = [NSString stringWithFormat:@"%0.1f",price - entity.preferential];
    }
    
    [NSThread detachNewThreadSelector:@selector(totalAllPrice) toTarget:self withObject:nil];
}

/** 满减计算 */

//- (CGFloat)storePreferentialArray:(NSArray *)array totalPrice:(CGFloat)price {
//
//    CGFloat needToPrice;        //需要达到的数值
//    CGFloat preferential;       //达成后减免的金额
//
//    CGFloat returePrice = 0.0;
//
//    for (NSDictionary *dic in array) {
//        needToPrice =  [[dic valueForKey:@"om"]floatValue];
//        preferential = [[dic valueForKey:@"m"]floatValue];
//
//        if (price >= needToPrice) {
//            returePrice = preferential;
//        } else {
//            break;
//        }
//    }
//
//    return returePrice;
//}
//
///** 满折计算 */
//
//- (CGFloat)storeDiscountArray:(NSArray *)array totalPrice:(CGFloat)price totalNumber:(NSInteger)number {
//
//    NSInteger needToNumber;     //需要达到的数值
//    CGFloat discount;           //达成后减免的折扣
//
//    CGFloat returePrice = 0.0;
//
//    for (NSDictionary *dic in array) {
//        needToNumber =  [[dic valueForKey:@"om"]integerValue];
//        discount = [[dic valueForKey:@"m"]floatValue];
//
//        if (number >= needToNumber) {
//            returePrice = price * (1-discount/10);
//        } else {
//            break;
//        }
//    }
//
//    NSLog(@"%0.1f * (1-%0.1f/10) = %f",price,discount,returePrice);
//    return returePrice;
//}

/** 统计全部已勾选商品总价 */
- (void) totalAllPrice {
    float allPrice = 0.0;
    float preferential = 0.0;
    for (int i = 0; i < proData.count; i ++) {
        CartProductEntity *entity = [proData objectAtIndex:i];
        if ([entity.chooseTag integerValue] == 1) {
            allPrice += [entity.price floatValue]*[entity.number floatValue];
        }
    }
    
    //    for (int i = 0; i < stoData.count; i ++) {
    //        CartStoreEntity *entity = [stoData objectAtIndex:i];
    //        allPrice += [entity.discountPrice floatValue];
    //        preferential += entity.preferential;
    //    }
    NSLog(@"allPrice:%f",allPrice);
    labelCount.text = [NSString stringWithFormat:@"总计：¥%0.1f",allPrice];
    //    labelPreferential.text = [NSString stringWithFormat:@"为你节省：¥%0.1f",preferential];
    
}

@end