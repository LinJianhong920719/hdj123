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
    
    //    ProductEntity *entity = [_data objectAtIndex:[indexPath row]];
    
    //    OrderDetailsViewController *detailsView = [[OrderDetailsViewController alloc]init];
    //    detailsView.orderID = entity.orderID;
    //    detailsView.title = @"订单详情";
    //    detailsView.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailsView animated:YES];
    
    //    [_mTableView deselectRowAtIndexPath:indexPath animated:YES];
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
//    NSLog(@"userId:%@",[Tools stringForKey:KEY_USER_ID]);
//    
//    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
////                         cardNumberField.text,     @"card_num",
//                         @"R4DRITDR1472116232",     @"card_num",
//                         [Tools stringForKey:KEY_USER_ID],@"userId",
//                         nil];
//    
//    NSString *path = [NSString stringWithFormat:@"/Api/Coupon/activate?"];
//    NSLog(@"dics:%@",dics);
//    [HYBNetworking updateBaseUrl:SERVICE_URL];
//
//    /*!
//     *
//     *
//     *  POST请求接口，若不指定baseurl，可传完整的url
//     *
//     *  @param url      接口路径，如/path/getArticleList
//     *  @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
//     *  @param emphasis 是否重点加密。只是针对重要数据接口（如：登录、注册、修改密码），只能通过人为手动判断
//     *  @param params   接口中所需的参数，如@{"categoryid" : @(12)}
//     *  @param success  接口成功请求到数据的回调
//     *  @param fail     接口请求数据失败的回调
//     *
//     *  @return 返回的对象中有可取消请求的API
//     */
//    [HYBNetworking postWithUrl:path refreshCache:YES emphasis:NO params:dics success:^(id response) {
//        NSDictionary *dic = response;
//        NSLog(@"response:%@",response);
//        NSString *statusMsg = [dic valueForKey:@"status"];
//        if([statusMsg intValue] == 4001){
//            //弹框提示获取失败
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"获取失败!";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//            return;
//        }if([statusMsg intValue] == 201){
//            //弹框提示获取失败
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"无数据";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//            return;
//        }if([statusMsg intValue] == 4002){
//            [self showHUDText:@"获取失败!"];
//        }else{
//            [self showHUDText:@"兑换成功!"];
//            [self loadData];
//            [_mTableView reloadData];
//        }
//        
//    } fail:^(NSError *error) {
//        NSLog(@"error:%@",error);
//    }];

}

-(void)post
{
         //对请求路径的说明
         //http://120.25.226.186:32812/login
         //协议头+主机地址+接口名称
         //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
         //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
         //1.创建会话对象
         NSURLSession *session = [NSURLSession sharedSession];
    
         //2.根据会话对象创建task
         NSURL *url = [NSURL URLWithString:@"http://120.25.77.182/Api/Coupon/activate?"];
    
         //3.创建可变的请求对象
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
         //4.修改请求方法为POST
         request.HTTPMethod = @"POST";
    
         //5.设置请求体
        request.HTTPBody = [@"card_num=IEDG6HBQ1472116232&userId=7" dataUsingEncoding:NSUTF8StringEncoding];
    
         //6.根据会话对象创建一个Task(发送请求）
         /*
                  第一个参数：请求对象
                  第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
                             data：响应体信息（期望的数据）
                             response：响应头信息，主要是对服务器端的描述
                             error：错误信息，如果请求失败，则error有值
                  */
         NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
                 //8.解析数据
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                 NSLog(@"333:%@",dict);
             
             }];
    
         //7.执行任务
         [dataTask resume];
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
