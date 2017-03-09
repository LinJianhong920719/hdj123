//
//  SetupViewController.m
//  设置
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "SetupViewController.h"
#import "MineViewControllers.h"
#import "RegisterViewControllerNew.h"
#import "XFWkwebView.h"
#import "AboutViewController.h"

@interface SetupViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSArray *_data;
    NSDictionary *dic01;
    NSDictionary *dic10;
    NSDictionary *dic03;
}
@property (strong, nonatomic) UITableView *_tableView;
@end

@implementation SetupViewController
@synthesize _tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //初始化UI视图
    [self initUI];
    //自定义数据
    [self customData];
}

- (void)customData {
    
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"关于我们",@"title",@"wm-064.png",@"imageName",@"2",@"viewType",nil];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"清除缓存",@"title",@"wm-056.png",@"imageName",@"3",@"viewType",nil];
    
    
    dic10 = [NSDictionary dictionaryWithObjectsAndKeys:@"退出当前账号",@"title",@"wm-030.png",@"imageName",@"10",@"viewType",nil];
    dic03 = [NSDictionary dictionaryWithObjectsAndKeys:@[dic10],@"section",nil];
    if ([Tools boolForKey:KEY_IS_LOGIN]!= YES) {
        dic01 = [NSDictionary dictionaryWithObjectsAndKeys:@[dic2],@"section",nil];
    }else{
        dic01 = [NSDictionary dictionaryWithObjectsAndKeys:@[dic2,dic3],@"section",nil];
    }
    
    if([Tools boolForKey:KEY_IS_LOGIN]==YES){
        _data = @[dic01,dic03];
    }else{
        _data = @[dic01];
    }
    
    
    
    
}

- (void)initUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY-8, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY-42) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BGCOLOR_DEFAULT;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 8)];
    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableHeaderView = tableHeaderView;
    
    //去除tableView底部多余分割线
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _tableView.tableFooterView = tableFooterView;
    
}

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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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
    //
    //    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-23, 15, 7, 14)];
    //    [arrow setImage:[UIImage imageNamed:@"wm-019.png"]];
    //    [cell addSubview:arrow];
    //
    //    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(18, 12, 20, 20)];
    //    [cell addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
    label.textColor = FONT_COLOR;
    label.font = [UIFont systemFontOfSize:13];
    [cell addSubview:label];
    
    if ([_data count] > 0) {
        
        NSDictionary *dic = [_data objectAtIndex:[indexPath section]];
        NSArray *array = [[dic valueForKey:@"section"] objectAtIndex:[indexPath row]];
        
        label.text = [array valueForKey:@"title"];
        //        [image setImage:[UIImage imageNamed:[array valueForKey:@"imageName"]]];
        
        if ([[array valueForKey:@"viewType"]integerValue] == 10) {
            //            arrow.hidden = YES;
            //            image.hidden = YES;
            [label setBackgroundColor:UIColorWithRGBA(255, 80, 0, 1)];
            [label setFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 40)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:[UIColor whiteColor]];
            [label setFont:[UIFont systemFontOfSize:15]];
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
            //意见反馈
            if([Tools boolForKey:KEY_IS_LOGIN]== YES){
                //                FeedBackViewController *feedBackView = [[FeedBackViewController alloc]init];
                //                feedBackView.title = @"意见反馈";
                //                feedBackView.hidesBottomBarWhenPushed = YES;
                //                feedBackView.navigationController.navigationBarHidden = YES;
                //                [self.navigationController pushViewController:feedBackView animated:YES];
            }else{
                //                RegisteredViewController *registeredView = [[RegisteredViewController alloc]init];
                //                registeredView.title = @"快捷登陆";
                //                registeredView.hidesBottomBarWhenPushed = YES;
                //                registeredView.navigationController.navigationBarHidden = YES;
                //                [self.navigationController pushViewController:registeredView animated:YES];
            }
            
            
        } break;
        case 2: {
            //关于我们
            AboutViewController *aboutUsView = [[AboutViewController alloc]init];
            aboutUsView.title = @"关于我们";
            aboutUsView.hidesBottomBarWhenPushed = YES;
            aboutUsView.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:aboutUsView animated:YES];

        } break;
        case 3: {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            hud.labelText = @"清除缓存成功";
            //通过多线程执行清除 避免执行过程中阻塞主线程 导致界面短时间无响应
            [NSThread detachNewThreadSelector:@selector(myThreadMainMethod) toTarget:self withObject:nil];        } break;
        
        case 10: {
            if([Tools boolForKey:KEY_IS_LOGIN]== YES){
            //退出当前账号
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定登出？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 101;
            [alert show];
            }
        } break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self logout];
    }
    
}
- (void)logout {
    [Tools saveObject:@"" forKey:KEY_USER_ID];
    [Tools saveObject:@"" forKey:KEY_USER_NAME];
    [Tools saveObject:@"" forKey:KEY_USER_PHONE];
    [Tools saveObject:@"" forKey:KEY_USER_IMAGE];
    [Tools saveBool:NO forKey:KEY_IS_LOGIN];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNum" object:nil];  //通知购物车数量刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMineView" object:nil];  //通知我的页面刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCart" object:nil];      //通知购物车刷新
    [self goToLoginView];
    
  
}
#pragma mark -

-(void)myThreadMainMethod {
    //获取caches路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *cachesPath = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
    
    //调用清除缓存方法
    [Tools clearCaches];

}
- (void)goToLoginView {
//    RegisterViewControllerNew *loginView = [[RegisterViewControllerNew alloc]init];
//    loginView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:loginView animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
