//
//  NewCouponsViewController.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/24.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "NewCouponsViewController.h"
#import "CouponsEntity.h"
#import "EffectiveCouponsCell.h"

#define Reality_viewHeight ScreenHeight-ViewOrignY-40-50
#define Reality_viewWidth ScreenWidth
@interface NewCouponsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UIView * topsView;
    UITextField *cardNumberField;
    UIButton *cardBtn;
    NSString *type;
}
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSMutableArray* data;
@end

@implementation NewCouponsViewController
@synthesize mTableView = _mTableView;
@synthesize data = _data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏导航栏
    [self hideNaviBar:YES];
    [self initUI];
    [self loadData];
    [self setupHeader];
    
}

#pragma mark - 初始化UI



- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Reality_viewWidth, ScreenHeight-100) style:UITableViewStylePlain];
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
}

- (void)initTableHeaderView {
    
    
    topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 40)];
    topsView.backgroundColor = [UIColor whiteColor];
    
    //激活码码输入框
    cardNumberField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, 0.72*ScreenWidth, 30)];
    cardNumberField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    [cardNumberField setFont:[UIFont systemFontOfSize:12]];
    //设置圆角
    cardNumberField.layer.cornerRadius =5.0;
    cardNumberField.borderStyle = UITextBorderStyleRoundedRect;
    cardNumberField.placeholder = @"  请输入优惠码";
    cardNumberField.delegate = self;
    cardNumberField.returnKeyType = UIReturnKeyNext;
    cardNumberField.keyboardType = UIKeyboardTypeDefault;
    cardNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cardNumberField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [topsView addSubview:cardNumberField];
    
    cardBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(cardNumberField)+10, 5, 0.187*ScreenWidth, 30)];
    [cardBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [cardBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:80/255.0f blue:0 alpha:1.0]];
    [cardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cardBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];

    [cardBtn addTarget:self action:@selector(cardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topsView addSubview:cardBtn];
    
    
    _mTableView.tableHeaderView = topsView;
}

#pragma mark - 加载数据

- (void)loadData {
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         @"1",     @"status",
                         [Tools stringForKey:KEY_USER_ID],@"userId",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"/Api/Coupon/show?"];
    
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
                    
                    CouponsEntity *entity = [[CouponsEntity alloc]initWithAttributes:proDiction];
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
    EffectiveCouponsCell *cell = (EffectiveCouponsCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EffectiveCouponsCell";
    EffectiveCouponsCell *cell = (EffectiveCouponsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EffectiveCouponsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([_data count] > 0) {
        CouponsEntity *entity = [_data objectAtIndex:[indexPath row]];
        cell.couponsDate.text = [NSString stringWithFormat:@"%@ - %@",entity.startTime,entity.endTime];
        cell.couponsGoods.text = @"指定商品专享";
        if([entity.type isEqualToString:@"0"]){
            type = @"元直减";
            cell.couponsName.text = [NSString stringWithFormat:@"%@%@",[self removeFloatAllZero:entity.expValue],type];
        }else if([entity.type isEqualToString:@"1"]){
            type = @"满50减";
            
            cell.couponsName.text = [NSString stringWithFormat:@"%@%@",type,[self removeFloatAllZero:entity.expValue]];
        }else if ([entity.type isEqualToString:@"2"]){
            type = @"满100减";
            cell.couponsName.text = [NSString stringWithFormat:@"%@%@",type,[self removeFloatAllZero:entity.expValue]];
        }
        
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        CouponsEntity *entity = [_data objectAtIndex:[indexPath row]];
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:@"myCoupon" object:entity];
            //返回上一层
            [self.navigationController popViewControllerAnimated:YES];
    
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
//兑换按钮
-(void)cardBtnClick:(UIButton*)btn{
    [self post];
    
}

-(void)post{
    // 1. URL
    NSString *path = [NSString stringWithFormat:@"/Api/Coupon/activate?"];
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVICE_URL,path]];
    
    // 2. 请求(可以改的请求)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // ? POST
    // 默认就是GET请求
    request.HTTPMethod = @"POST";
    // ? 数据体
    NSString *str = [NSString stringWithFormat:@"card_num=%@&userId=%@", cardNumberField.text, [Tools stringForKey:KEY_USER_ID]];
    // 将字符串转换成数据
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3. 连接,异步
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError == nil) {
            // 网络请求结束之后执行!
            // 将Data转换成字符串
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            // num = 2
            NSLog(@"%@ %@", str, [NSThread currentThread]);
            
            // 更新界面
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"str:%@",str);
                [self refeshOrder];
                
            }];
        }
    }];
    
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
