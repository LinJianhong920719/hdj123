//
//  MyWalletViewController.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletEntity.h"
#import "MyWalletCell.h"
#import "RechargeViewController.h"
#import "PaySuccessViewController.h"
#import "WithdrawalViewController.h"

#define Reality_viewHeight ScreenHeight-ViewOrignY-40-50
#define Reality_viewWidth ScreenWidth
@interface MyWalletViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UIView * topsView;
    UITextField *cardNumberField;
    UIButton *cardBtn;
    NSString *type;
    UILabel *money;
}
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSMutableArray* data;
@end

@implementation MyWalletViewController
@synthesize mTableView = _mTableView;
@synthesize data = _data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refeshData) name:@"refreshByWalletDetail"object:nil];

    [self initUI];
    [self loadData];
    [self setupHeader];
    [self setupFooter];
    _pageno = 1;
    
}

#pragma mark - 初始化UI



- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY, Reality_viewWidth, ScreenHeight-ViewOrignY) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.scrollsToTop = YES;
    _mTableView.backgroundColor = self.view.backgroundColor;
    _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_mTableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Reality_viewWidth, 1)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _mTableView.tableFooterView = tableFooterView;
    
    _mTableView.sectionHeaderHeight = 42;
    _mTableView.sectionFooterHeight = 10;
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTableHeaderView];
}

- (void)initTableHeaderView {
    
    
    topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 174)];
    topsView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DEVICE_SCREEN_SIZE_WIDTH, 20)];
    title.font = [UIFont systemFontOfSize:12];
    title.text = @"账户余额(元)";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = FONTS_COLOR102;
    [topsView addSubview: title];
    
    money = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(title), DEVICE_SCREEN_SIZE_WIDTH, 40)];
    money.font = [UIFont systemFontOfSize:28];
    money.text = @"0.00";
    money.textAlignment = NSTextAlignmentCenter;
    money.textColor = UIColorWithRGBA(255,80,0,1);
    [topsView addSubview:money];
    
    UIView *butView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(money)+5, DEVICE_SCREEN_SIZE_WIDTH, 60)];
    [topsView addSubview:butView];
    
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,5, DEVICE_SCREEN_SIZE_WIDTH/2-10, 30)];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    rechargeBtn.backgroundColor = RGB(72, 191, 98);
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rechargeBtn.titleLabel.textColor = [UIColor whiteColor];
    [rechargeBtn.layer setMasksToBounds:YES];
    [rechargeBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [rechargeBtn addTarget:self action:@selector(recharge:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:rechargeBtn];
    
    UIButton *withdrawalBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(rechargeBtn)+10,5, DEVICE_SCREEN_SIZE_WIDTH/2-20, 30)];
    [withdrawalBtn setTitle:@"提现" forState:UIControlStateNormal];
    withdrawalBtn.backgroundColor = RGB(255, 55, 0);
    withdrawalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    withdrawalBtn.titleLabel.textColor = [UIColor whiteColor];
    [withdrawalBtn.layer setMasksToBounds:YES];
    [withdrawalBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [withdrawalBtn addTarget:self action:@selector(withdrawal:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:withdrawalBtn];
    
    UIView *butomView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(butView), DEVICE_SCREEN_SIZE_WIDTH, 10)];
    butomView.backgroundColor = BGCOLOR_DEFAULT;
    [topsView addSubview:butomView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, viewBottom(butomView), DEVICE_SCREEN_SIZE_WIDTH, 30)];
    label.text = @"余额明细";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = FONTS_COLOR102;
    label.textAlignment = NSTextAlignmentLeft;
    [topsView addSubview:label];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewBottom(label), DEVICE_SCREEN_SIZE_WIDTH, 1)];
    line.backgroundColor = LINECOLOR_DEFAULT;
    [topsView addSubview:line];
    
    
    
    
    _mTableView.tableHeaderView = topsView;
}

#pragma mark - 加载数据

- (void)loadData {
    
    //获取用户余额
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         nil];
    NSString *path = [NSString stringWithFormat:@"/Api/Wallet/show?"];
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
        }else if([statusMsg intValue] == 200){
            
            NSString *amount = [[dic valueForKey:@"data"]valueForKey:@"amount"];
            money.text = [NSString stringWithFormat:@"¥ %@",amount];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    //获取余额明细
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"user_id",
                          [NSNumber numberWithInteger:_pageno], @"pager",
                         nil];
    NSString *paths = [NSString stringWithFormat:@"/Api/Wallet/getWalletUserLog?"];
    NSLog(@"dics:%@",dics);
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:paths refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
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
        }else if([statusMsg intValue] == 200){
            
            NSMutableArray *dataArray = [dic valueForKey:@"data"];
            for (NSDictionary* dic in dataArray) {
                MyWalletEntity* entity = [[MyWalletEntity alloc]initWithAttributes:dic];
                [_data addObject:entity];
            }
            [_mTableView reloadData];
            
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
            _pageno = 1;
            [self loadData];
            [_mTableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
//    [refreshHeader beginRefreshing];
}
-(void)refeshData{
    [self loadData];
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
         _pageno ++;
         [self loadData];
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
    MyWalletCell *cell = (MyWalletCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyWalletCell";
    MyWalletCell *cell = (MyWalletCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyWalletCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([_data count] > 0) {
        MyWalletEntity *entity = [_data objectAtIndex:[indexPath row]];
        cell.payTitle.text = entity.message;
        cell.payDate.text = entity.createTime;
        cell.payMoney.text = entity.val;
        cell.balance.text = [NSString stringWithFormat:@"余额:%@",entity.left_val];
    }
    return cell;
}

- (IBAction)backClick:(id)sender {
    // 返回上页
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    [cardNumberField resignFirstResponder];
    
    
}
//充值按钮
-(void)recharge:(UIButton*)btn{
    RechargeViewController *vc= [[RechargeViewController alloc]initWithNibName:@"RechargeViewController" bundle:[NSBundle mainBundle]];
    vc.title = @"充值";
    [self.navigationController pushViewController:vc animated:YES];
}
//提现按钮
-(void)withdrawal:(UIButton*)btn{
    WithdrawalViewController *vc= [[WithdrawalViewController alloc]initWithNibName:@"WithdrawalViewController" bundle:[NSBundle mainBundle]];
    vc.title = @"提现";
    [self.navigationController pushViewController:vc animated:YES];
}

//去掉小数点之后的0；
-(NSString*)removeFloatAllZero:(NSString*)string
{
    //    第二种方法
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}

@end
