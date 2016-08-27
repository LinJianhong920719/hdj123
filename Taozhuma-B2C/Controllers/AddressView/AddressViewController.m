//
//  AddressViewController.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/24.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressEntity.h"
#import "AddressCell.h"
#import "AddAddressViewController.h"
#import "AddressDetailViewController.h"

#define Reality_viewHeight ScreenHeight-ViewOrignY-40-50
#define Reality_viewWidth ScreenWidth
@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UIView * topsView;
    UITextField *cardNumberField;
    UIButton *cardBtn;
    NSString *type;
}
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSMutableArray* data;
@end

@implementation AddressViewController
@synthesize mTableView = _mTableView;
@synthesize data = _data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏导航栏
//    [self hideNaviBar:YES];
    [self initUI];
    [self loadData];
//    [self setupHeader];
    
}

#pragma mark - 初始化UI



- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY, Reality_viewWidth, ScreenHeight) style:UITableViewStylePlain];
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
    [self initTableHeaderView];
    
    
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_SCREEN_SIZE_HEIGHT-40, DEVICE_SCREEN_SIZE_WIDTH, 40)];
    buttomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttomView];
    
    UIButton *addAddressBtn = [[UIButton alloc]init];
    addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.layer.cornerRadius = 8;
    addAddressBtn.frame = CGRectMake(10, 5, DEVICE_SCREEN_SIZE_WIDTH-20, 30);


    [addAddressBtn setTitle:@"新增地址" forState:UIControlStateNormal];
    addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addAddressBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:80/255.0f blue:0 alpha:1.0]];
    [addAddressBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:addAddressBtn];
}

- (void)initTableHeaderView {
    
    
    topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 40)];
    topsView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *loadImage = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH*0.34, 12, 13, 13)];
    [loadImage setImage:[UIImage imageNamed:@"address_location"]];
    
    [topsView addSubview:loadImage];
    
    UILabel *loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(loadImage)+10, 5, 100, 30)];
    loadLabel.text = @"定位当前位置";
    loadLabel.font = [UIFont systemFontOfSize:12];
    loadLabel.textColor = [UIColor colorWithRed:255/255.0f green:80/255.0f blue:0 alpha:1.0];
    [topsView addSubview:loadLabel];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(loadLabel), DEVICE_SCREEN_SIZE_WIDTH, 10)];
    view.backgroundColor = BGCOLOR_DEFAULT;
    [topsView addSubview:view];
    
    
    _mTableView.tableHeaderView = topsView;
}

#pragma mark - 加载数据

- (void)loadData {
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"/Api/User/showAddress?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking postWithUrl:path refreshCache:YES params:dic success:^(id response) {
        
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
            if([[dic valueForKey:@"data"] count] > 0 && [dic valueForKey:@"data"] != nil){
                for(NSDictionary *proDiction in [dic valueForKey:@"data"]){
                    
                    AddressEntity *entity = [[AddressEntity alloc]initWithAttributes:proDiction];
                    [_data addObject:entity];
                    
                }
                [_mTableView reloadData];
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

#pragma mark - SDRefresh

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    [refreshHeader addToScrollView:_mTableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            _pageno = 1;
            [self loadData];
            //            [_mTableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}
-(void)refeshOrder{
    //    _pageno = 1;
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
        //        _pageno ++;
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
    AddressCell *cell = (AddressCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AddressCell";
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([_data count] > 0) {
        AddressEntity *entity = [_data objectAtIndex:[indexPath row]];
        cell.userName.text = entity.guestName;
        cell.userPhone.text = entity.mobile;
        cell.userAddress.text = entity.address;
        
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        AddressEntity *entity = [_data objectAtIndex:[indexPath row]];
    
        AddressDetailViewController *addressDetail = [[AddressDetailViewController alloc]init];
        addressDetail.addressId = entity.addressID;
        addressDetail.title = @"订单详情";
        addressDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressDetail animated:YES];
    
        [_mTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)backClick:(id)sender {
    // 返回上页
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    [cardNumberField resignFirstResponder];
    
    
}


//去掉小数点之后的0；
-(NSString*)removeFloatAllZero:(NSString*)string
{

    //    第二种方法
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    
    
    return outNumber;
}

//新增地址
- (IBAction)addClick:(id)sender {
    AddAddressViewController *addAddressView = [[AddAddressViewController alloc]init];
    addAddressView.title = @"添加地址";
    addAddressView.hidesBottomBarWhenPushed = YES;
    addAddressView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:addAddressView animated:YES];
}

@end
