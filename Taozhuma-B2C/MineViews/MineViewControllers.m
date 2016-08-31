//
//  MineViewController.m
//  我的
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "MineViewControllers.h"
#import "MineOrderCellView.h"
#import "RegisterViewControllerNew.h"
#import "CollectionListViewController.h"
#import "CouponsViewController.h"
#import "NewCouponsViewController.h"
#import "UseCouponsViewController.h"
#import "OverdueCouponsViewController.h"
#import "AddressViewController.h"
#import "SetupViewController.h"
#import "EditUserInfoViewController.h"
#import "MyWalletViewController.h"
#import "UMSocial.h"

@interface MineViewControllers () <UITableViewDataSource,UITableViewDelegate> {
    NSArray *_data;
    UILabel *userName;
    UIImageView *logoImageView;
    NSString *passWord;
    MineOrderCellView *tableHeaderView;
}
@property (strong, nonatomic) UITableView *_tableView;

@end

@implementation MineViewControllers
@synthesize _tableView;


- (void)loadView {
    [super loadView];
    self.title = @"我的";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMine:) name:@"refreshMine"object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   

    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //隐藏导航栏
    [self hideNaviBar:YES];
    //初始化UI视图
    [self initUI];
    //自定义数据
    [self customData];
    
    [self initTableHeaderView];
}

//- (void)grabSingle:(NSNotification*)notification {
//    NSString *obj = [notification object];
//    //是否是当前正在显示
//    if ([Tools intForKey:KEY_TabBarNum] == 2) {
//        OrdersDetailsController *ordersDetails = [[OrdersDetailsController alloc]init];
//        ordersDetails.title = @"订单详情";
//        ordersDetails.orderID = obj;
//        ordersDetails.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:ordersDetails animated:YES];
//    }
//}

- (void)customData {
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"我的钱包",@"title",@"user_wallet",@"imageName",@"1",@"viewType",nil];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"优惠卷",@"title",@"user_coupon",@"imageName",@"2",@"viewType",nil];
    NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"我的收藏",@"title",@"user_favorites",@"imageName",@"3",@"viewType",nil];

    NSDictionary *dic6 = [NSDictionary dictionaryWithObjectsAndKeys:@"收货地址",@"title",@"user_address",@"imageName",@"4",@"viewType",nil];
    
    
    NSDictionary *dic7 = [NSDictionary dictionaryWithObjectsAndKeys:@"在线客服",@"title",@"user_service",@"imageName",@"5",@"viewType",nil];
    NSDictionary *dic8 = [NSDictionary dictionaryWithObjectsAndKeys:@"帮助中心",@"title",@"user_help",@"imageName",@"6",@"viewType",nil];
    
    
    NSDictionary *dic01 = [NSDictionary dictionaryWithObjectsAndKeys:@[dic1,dic3,dic4,dic6],@"section",nil];
    NSDictionary *dic02 = [NSDictionary dictionaryWithObjectsAndKeys:@[dic7,dic8],@"section",nil];
    _data = @[dic01,dic02];

    
    
    
}
- (void) refreshMine:(NSNotification*) notification{

    [self customData];
    [self initUI];
}
- (void) Update:(NSNotification*) notification{
    [self initUI];
}
- (void)initUI {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 180)];
    //用户背景一
    UIImageView * backgroundImageOne = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 190)];
    [backgroundImageOne setImage:[UIImage imageNamed:@"user_bg"]];
    [headView addSubview:backgroundImageOne];
    
    //用户背景二
    UIImageView * backgroundImageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 123, DEVICE_SCREEN_SIZE_WIDTH, 77)];
    [backgroundImageTwo setImage:[UIImage imageNamed:@"user_mask"]];
    [headView addSubview:backgroundImageTwo];
    
    [self.view addSubview:headView];

  
    //添加中间用户头像显示
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((headView.frame.size.width-75)/2, 75, 90, 90)];
    
    
    if([Tools boolForKey:KEY_IS_LOGIN]!= YES){
        logoImageView.image = [UIImage imageNamed:@"head_bg"];
    }else{
        if([Tools stringForKey:KEY_USER_IMAGE].length>0){
            logoImageView.layer.cornerRadius = 42.5;
            logoImageView.layer.masksToBounds = YES;
            logoImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
            logoImageView.layer.borderWidth = 2;
            [logoImageView sd_setImageWithURL:[NSURL URLWithString:[Tools stringForKey:KEY_USER_IMAGE]] placeholderImage:[UIImage imageNamed:@"head_bg"]];
        }else{
            logoImageView.image = [UIImage imageNamed:@"head_bg"];
        }
        
    }
    //为UIImageView添加事件侦听
    logoImageView.userInteractionEnabled=YES;
    if([Tools boolForKey:KEY_IS_LOGIN]!= YES){
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [logoImageView addGestureRecognizer:singleTap];
    }else{
        UITapGestureRecognizer *singleTaps =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editUserInfoImage:)];
        [logoImageView addGestureRecognizer:singleTaps];
    }
//
    [headView addSubview:logoImageView];
//
//    //添加用户昵称
    userName = [[UILabel alloc]initWithFrame:CGRectMake((headView.frame.size.width-75)/2, viewBottom(logoImageView)+5, 90, 20)];
    
    if([Tools boolForKey:KEY_IS_LOGIN]!= YES){
        userName.text = @"快捷登录";
        userName.textAlignment = NSTextAlignmentCenter;
        userName.font = [UIFont boldSystemFontOfSize:16];
        userName.textColor = FONTS_COLOR51;
    }else{
        userName.text = [Tools stringForKey:KEY_USER_NAME];
        userName.textAlignment = NSTextAlignmentCenter;
        userName.font = [UIFont boldSystemFontOfSize:14];
        userName.textColor = FONTS_COLOR51;
    }
    
    [headView addSubview:userName];
    
    //添加左边信息设置按钮
    UIButton *setShareButton = [[UIButton alloc]initWithFrame:CGRectMake(10*PROPORTION, 30, 40, 40)];
    [setShareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];//设置按钮的图片
    [setShareButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8) ];//将按钮的上下左右都缩进8个单位
    [setShareButton addTarget:self action:@selector(ShareClick:) forControlEvents:UIControlEventTouchUpInside];//为按钮增加时间侦听
    [headView addSubview:setShareButton];
    
    
    //添加右边信息设置按钮
    UIButton *setInformationButton = [[UIButton alloc]initWithFrame:CGRectMake(270*PROPORTION, 30, 40, 40)];
    [setInformationButton setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];//设置按钮的图片
    [setInformationButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8) ];//将按钮的上下左右都缩进8个单位
    [setInformationButton addTarget:self action:@selector(InformationClick:) forControlEvents:UIControlEventTouchUpInside];//为按钮增加时间侦听
    [headView addSubview:setInformationButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, viewBottom(headView) + 18, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT - viewBottom(headView) - 42) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = BGCOLOR_DEFAULT;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.view addSubview:_tableView];
    [self.view bringSubviewToFront:headView];
    
//    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 8)];
//    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
//    _tableView.tableHeaderView = tableHeaderView;
    
    //去除tableView底部多余分割线
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableFooterView = tableFooterView;
    
}

- (void)initTableHeaderView {
    tableHeaderView = [[MineOrderCellView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) Delegated:self];
    _tableView.tableHeaderView = tableHeaderView;
    

    
}

//白色边框实现方法
- (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    //圆的边框宽度为2，颜色为红色
    CGContextSetLineWidth(context,16);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    //在圆区域内画出image原图
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}


-(IBAction)onClickImage:(id)sender{
    RegisterViewControllerNew *registeredView = [[RegisterViewControllerNew alloc]init];
    //registeredView.title = @"快捷登录";
    registeredView.hidesBottomBarWhenPushed = YES;
    registeredView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:registeredView animated:YES];
}
-(IBAction)editUserInfoImage:(id)sender{
    NSLog(@"该方法尚未实现");
    EditUserInfoViewController *registeredView = [[EditUserInfoViewController alloc]init];
    registeredView.title = @"修改信息";
    registeredView.hidesBottomBarWhenPushed = YES;
    registeredView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:registeredView animated:YES];
}
//设置按钮
//- (IBAction)InformationClick:(id)sender {
//    SetupViewController *setupView = [[SetupViewController alloc]init];
//    setupView.title = @"设置";
//    setupView.hidesBottomBarWhenPushed = YES;
//    setupView.navigationController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:setupView animated:YES];
//}

#pragma mark - UITableView

//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_data count];
}

// section 头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 8)];
    [view setBackgroundColor:BGCOLOR_DEFAULT];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7.5, DEVICE_SCREEN_SIZE_WIDTH, 0.5)];
    [line setBackgroundColor:LINECOLOR_DEFAULT];
    [view addSubview:line];
    
    return view;
}

// section 头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [view setBackgroundColor:BGCOLOR_DEFAULT];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 0.5)];
    [line setBackgroundColor:LINECOLOR_DEFAULT];
    [view addSubview:line];
    
    return view;
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

//指定每个分区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //获取分组里面的数组
    NSDictionary *dic = [_data objectAtIndex:section];
    return [[dic valueForKey:@"section"] count];
}

//设置每行调用的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = nil;
    
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    } else {
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-23, 15, 7, 14)];
    [arrow setImage:[UIImage imageNamed:@"more2"]];
    [cell addSubview:arrow];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(18, 12, 20, 20)];
    [cell addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 44)];
    label.textColor = FONT_COLOR;
    label.font = [UIFont systemFontOfSize:15];
    [cell addSubview:label];
    
    if ([_data count] > 0) {
        
        NSDictionary *dic = [_data objectAtIndex:[indexPath section]];
        NSArray *array = [[dic valueForKey:@"section"] objectAtIndex:[indexPath row]];
        
        label.text = [array valueForKey:@"title"];
        [image setImage:[UIImage imageNamed:[array valueForKey:@"imageName"]]];
        
        if ([[array valueForKey:@"viewType"]integerValue] == 10) {
            arrow.hidden = YES;
            [image setFrame:CGRectMake(85*PROPORTION, 12, 20, 20)];
            [label setFrame:CGRectMake(viewRight(image)+5, 12, 180, 20)];
        }
    }
    
    return cell;
}

//设置选中Cell的响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [_data objectAtIndex:[indexPath section]];
    NSArray *array = [[dic valueForKey:@"section"] objectAtIndex:[indexPath row]];
    NSInteger type = [[array valueForKey:@"viewType"] integerValue];
    
    switch (type) {
        case 1: {
            //我的钱包
            if([Tools boolForKey:KEY_IS_LOGIN]== YES){
                MyWalletViewController *myWalletView = [[MyWalletViewController alloc]init];
                myWalletView.title = @"我的钱包";
                myWalletView.hidesBottomBarWhenPushed = YES;
                myWalletView.navigationController.navigationBarHidden = YES;
                [self.navigationController pushViewController:myWalletView animated:YES];
                
            }else{
                RegisterViewControllerNew *registeredView = [[RegisterViewControllerNew alloc]init];
                registeredView.title = @"快捷登陆";
                registeredView.hidesBottomBarWhenPushed = YES;
                registeredView.navigationController.navigationBarHidden = YES;
                [self.navigationController pushViewController:registeredView animated:YES];
            }
            
        } break;
        case 2: {
            //我的优惠卷
            if([Tools boolForKey:KEY_IS_LOGIN]== YES){
                CouponsViewController * couponsTotalView = [[CouponsViewController alloc]init];
                couponsTotalView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:couponsTotalView animated:YES];
    
            }else{
                RegisterViewControllerNew *registeredView = [[RegisterViewControllerNew alloc]init];
                registeredView.title = @"快捷登陆";
                registeredView.hidesBottomBarWhenPushed = YES;
                registeredView.navigationController.navigationBarHidden = YES;
                [self.navigationController pushViewController:registeredView animated:YES];
            }
            
        }break;
        case 3: {
            //我的收藏
            if([Tools boolForKey:KEY_IS_LOGIN]== YES){
                CollectionListViewController * collectionListView = [[CollectionListViewController alloc]init];
                collectionListView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collectionListView animated:YES];
            }else{
                RegisterViewControllerNew *registeredView = [[RegisterViewControllerNew alloc]init];
                registeredView.title = @"快捷登陆";
                registeredView.hidesBottomBarWhenPushed = YES;
                registeredView.navigationController.navigationBarHidden = YES;
                [self.navigationController pushViewController:registeredView animated:YES];
            }
            
        } break;
        case 4: {
            //我的送餐地址
            if([Tools boolForKey:KEY_IS_LOGIN]== YES){
                AddressViewController *addressListView = [[AddressViewController alloc]init];
                addressListView.title = @"我的地址";
                addressListView.hidesBottomBarWhenPushed = YES;
                addressListView.navigationController.navigationBarHidden = YES;
                [self.navigationController pushViewController:addressListView animated:YES];
            }else{
                RegisterViewControllerNew *registeredView = [[RegisterViewControllerNew alloc]init];
                registeredView.title = @"快捷登陆";
                registeredView.hidesBottomBarWhenPushed = YES;
                registeredView.navigationController.navigationBarHidden = YES;
                [self.navigationController pushViewController:registeredView animated:YES];
                
            }
            
        } break;
        case 5: {
            //客服电话
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"1008611"];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        } break;
        case 6: {
            //帮助中心
            
            
        } break;
//        case 7: {
//            //意见反馈
//            if([Tools boolForKey:KEY_IS_LOGIN]== YES){
//                FeedBackViewController *feedBackView = [[FeedBackViewController alloc]init];
//                feedBackView.title = @"意见反馈";
//                feedBackView.hidesBottomBarWhenPushed = YES;
//                feedBackView.navigationController.navigationBarHidden = YES;
//                [self.navigationController pushViewController:feedBackView animated:YES];
//            }else{
//                RegisteredViewController *registeredView = [[RegisteredViewController alloc]init];
//                registeredView.title = @"快捷登陆";
//                registeredView.hidesBottomBarWhenPushed = YES;
//                registeredView.navigationController.navigationBarHidden = YES;
//                [self.navigationController pushViewController:registeredView animated:YES];
//            }
//            
//        } break;
//        case 8: {
//            //关于我们
//            AboutUsViewController *aboutUsView = [[AboutUsViewController alloc]init];
//            aboutUsView.title = @"关于我们";
//            aboutUsView.helpId = @"2";
//            aboutUsView.hidesBottomBarWhenPushed = YES;
//            aboutUsView.navigationController.navigationBarHidden = YES;
//            [self.navigationController pushViewController:aboutUsView animated:YES];
//            
//        } break;
    }
}
//
////判断钱包是否有密码
//- (void)isPassWord{
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
//                MyWalletViewController *myWalletView = [[MyWalletViewController alloc]init];
//                myWalletView.title = @"我的钱包";
//                myWalletView.hidesBottomBarWhenPushed = YES;
//                myWalletView.navigationController.navigationBarHidden = YES;
//                [self.navigationController pushViewController:myWalletView animated:YES];
//            }else{
//                [[[ZCTradeView alloc] init] show];
//                
//            }
//        }
//    }
//     ];
//}
//
//- (void) refresh:(NSNotification*) notification
//{
//    id obj = [notification object];//获取到传递的对象
//    passWord = obj;
//    [self setPassWord];
//}
//
////添加钱包密码
//- (void)setPassWord{
//    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
//                          @"add",                         @"act",
//                          @"e3dc653e2d68697346818dfc0b208322",       @"key",
//                          [Tools stringForKey:KEY_USER_ID],@"uid",
//                          [self md5:passWord],                         @"pass",
//                          nil];
//    NSLog(@"dic:%@", dics);
//    NSString *xpoint = WALLETXPOINT;
//    [MailWorldRequest requestWithParams:dics xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//        } else {
//            if (respond.result == YES) {
//                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"钱包密码设置成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                
//                [alter show];
//            }else{
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = respond.error_msg;
//                hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//            }
//            
//        }
//    }
//     ];
//}

//设置按钮
- (IBAction)InformationClick:(id)sender {
    SetupViewController *setupView = [[SetupViewController alloc]init];
    setupView.title = @"设置";
    setupView.hidesBottomBarWhenPushed = YES;
    setupView.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:setupView animated:YES];
}
//分享
- (IBAction)ShareClick:(id)sender {
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];
    [UMSocialData defaultData].extConfig.title = @"分享的title";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social"
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
@end
