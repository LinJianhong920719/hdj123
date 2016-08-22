//
//  SearchViewController.m
//  搜索
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//


#import "SearchViewController.h"

#define RecordCount 8      //最多存储5条，自定义
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SearchHistory"]
@interface SearchViewController ()  {
    NSArray *_data;
    UIView *topView;
    NSMutableArray *hotArray;
    UIButton *but;
    UITextField *searchLabel;
    NSArray *historyArray;
}


@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //隐藏导航栏
    [self hideNaviBar:YES];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    historyArray = [userDefaultes arrayForKey:@"SearchHistory"];
    
    hotArray = [[NSMutableArray alloc]init];

    
    [self getHotSearchList];

}
//初始化头部导航栏
-(void)initTopNav{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    topView.backgroundColor = BACK_DEFAULT;
    //搜索view
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(10, 28, ScreenWidth*0.83, 29)];
    searchView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.1];
    //设置圆角
    searchView.layer.cornerRadius = 5;
    searchView.layer.masksToBounds = YES;
    
    //搜索图标
    UIImageView *_serachImage = [[UIImageView alloc]init];
    [_serachImage setFrame:CGRectMake(10, 10, 10, 10)];
    [_serachImage setImage:[UIImage imageNamed:@"icon_search"]];
    [searchView addSubview:_serachImage];
    //搜索field
    searchLabel = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(_serachImage)+10, 0, searchView.frame.size.width-_serachImage.frame.size.width-15, 29)];
    searchLabel.font = [UIFont systemFontOfSize:12];
    searchLabel.placeholder = @"请输入商品名称";
    searchLabel.backgroundColor = [UIColor clearColor];
    searchLabel.keyboardType = UIKeyboardTypeDefault;
    searchLabel.returnKeyType = UIReturnKeyDone;
    [searchLabel addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [searchView addSubview:searchLabel];
    //取消按钮
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(searchLabel)+15, 37, 24, 11)];
    [backBut setTitle:@"取消" forState:UIControlStateNormal];
    backBut.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    backBut.backgroundColor = [UIColor clearColor];
    //设置圆角

    [backBut setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    //将按钮添加到topView中
    [topView addSubview:backBut];
    //将视图添加到topView中
    [topView addSubview:searchView];
    
    [self.view addSubview:topView];
    //将一个UIView显示在最前面只需要调用其父视图的 bringSubviewToFront（）方法
    [self.view bringSubviewToFront:topView];
    
    //搜索界面下部分view
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(topView), ScreenWidth, ScreenHeight-topView.frame.size.height)];
    backView.backgroundColor = BGCOLOR_DEFAULT;
    [self.view addSubview:backView];
    
    //搜索历史
    UIView *historySearchView = [[UIView alloc]init];
    if([historyArray count] == 0){
        [historySearchView setFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    }else if([historyArray count] >0 && [historyArray count] <5){
        [historySearchView setFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    }
    else{
      [historySearchView setFrame:CGRectMake(0, 0, ScreenWidth, 109)];
    }
//    historySearchView.backgroundColor = [UIColor greenColor];
    UIImageView *sImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 12, 12)];
    [sImage setImage:[UIImage imageNamed:@"search_history"]];
    [historySearchView addSubview:sImage];
    
    UILabel *sLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(sImage)+5, 20, 100, 13)];
    sLabel.font =[UIFont systemFontOfSize:12];
    sLabel.textColor = FONTS_COLOR153;
    sLabel.text = @"搜索历史";
    [historySearchView addSubview:sLabel];
    
    UIButton *delBut = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*0.9, 20, 11, 12)];
    [delBut setBackgroundImage:[UIImage imageNamed:@"search_del"] forState:UIControlStateNormal];
    [delBut addTarget:self action:@selector(delButClick:) forControlEvents:UIControlEventTouchUpInside];
    [historySearchView addSubview:delBut];
    int i = 0;
    int j;
    for (NSString *serMsg in historyArray) {
        if(i >= 4){
            j=i-4;
            but = [[UIButton alloc]initWithFrame:CGRectMake(20+70*j, viewBottom(sLabel)+40, 60, 25)];
        }else{
            
            but = [[UIButton alloc]initWithFrame:CGRectMake(20+70*i, viewBottom(sLabel)+10, 60, 25)];
 
        }

        [but setTitle:serMsg forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize: 10.0];
        [but setBackgroundColor:[UIColor whiteColor]];
        [but setTitleColor:FONTS_COLOR153 forState:UIControlStateNormal];
        [but.layer setMasksToBounds:YES];
        [but.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        [but.layer setBorderWidth:0.8]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 153, 153, 153, 1 });
        
        [but.layer setBorderColor:colorref];//边框颜色
        
        [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [historySearchView addSubview:but];
        i++;
    }
    
    
    [backView addSubview:historySearchView];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(20, viewBottom(historySearchView)+5, ScreenWidth-40, 1)];
    line.backgroundColor = LINECOLOR_DEFAULT;
    [backView addSubview:line];
    
    
    //热门搜索
    UIView *hotSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(line), ScreenWidth, 129)];
//        hotSearchView.backgroundColor = [UIColor greenColor];
    UIImageView *hImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 12, 12)];
    [hImage setImage:[UIImage imageNamed:@"search_hot"]];
    [hotSearchView addSubview:hImage];
    
    UILabel *hLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(hImage)+5, 20, 100, 13)];
    hLabel.font =[UIFont systemFontOfSize:12];
    hLabel.textColor = [UIColor redColor];
    hLabel.text = @"热门搜索";
    [hotSearchView addSubview:hLabel];
    
    
    int i2 = 0;
    int j2;
    for (NSString *serMsg2 in hotArray) {
        if(i2 >= 4 && i2<8){
            j2=i2-4;
            but = [[UIButton alloc]initWithFrame:CGRectMake(20+70*j2, viewBottom(hLabel)+40, 60, 25)];
        }else if (i2>=8){
            j2=i2-8;
            but = [[UIButton alloc]initWithFrame:CGRectMake(20+70*j2, viewBottom(hLabel)+70, 60, 25)];
        }else{
            but = [[UIButton alloc]initWithFrame:CGRectMake(20+70*i2, viewBottom(hLabel)+10, 60, 25)];
        }
        

        [but setTitle:serMsg2 forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize: 10.0];
        [but setBackgroundColor:[UIColor whiteColor]];
        [but setTitleColor:FONTS_COLOR153 forState:UIControlStateNormal];
        [but.layer setMasksToBounds:YES];
        [but.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        [but.layer setBorderWidth:0.5]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 153, 153, 153, 1 });
        
        [but.layer setBorderColor:colorref];//边框颜色
        [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [hotSearchView addSubview:but];
        i2++;
    }
    
    
    [backView addSubview:hotSearchView];
    
}


- (IBAction)backClick:(id)sender {
    // 返回上页
   [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)delButClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否清除搜索历史" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
    alert.tag = btn.tag;
    [alert show];
    
}
- (IBAction)butClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self toSearchProductList:btn.titleLabel.text];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    switch (buttonIndex) {
        case 0: //YES应该做的事
            [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]init] forKey:@"SearchHistory"];
            break;
        case 1://NO应该做的事
            break;
        default:
            break;
            
    }
}

//获取热门搜索信息
-(void)getHotSearchList{
    
    NSString *path = [NSString stringWithFormat:@"/Api/Goods/HotSearch?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:nil success:^(id response) {
        
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
            for(NSDictionary *hotSearch in [dic valueForKey:@"data"]){
                NSLog(@"keyword:%@",[hotSearch valueForKey:@"keyword"]);
                
                [hotArray addObject:[hotSearch valueForKey:@"keyword"]];
            }
            //初始化UI视图
            [self initTopNav];
        }
                
    } fail:^(NSError *error) {
        
    }];
}


//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    if (sender == searchLabel) {
        [self hideKeyboard];
        NSMutableArray *searchArray = [[NSMutableArray alloc]initWithArray:SEARCH_HISTORY];
        if (searchArray == nil) {
            searchArray = [[NSMutableArray alloc]init];
        } else if ([searchArray containsObject:searchLabel.text]) {
            [searchArray removeObject:searchLabel.text];
        } else if ([searchArray count] >= RecordCount) {
            [searchArray removeObjectsInRange:NSMakeRange(RecordCount - 1, [searchArray count] - RecordCount + 1)];
        }
        [searchArray insertObject:searchLabel.text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:searchArray forKey:@"SearchHistory"];
        [self toSearchProductList:searchLabel.text];
    }
}
//隐藏键盘方法
-(void)hideKeyboard{
    [searchLabel resignFirstResponder];
    
}

-(void)toSearchProductList:(NSString *)content{
        SearchProductListViewController *detailsView = [[SearchProductListViewController alloc]init];
        detailsView.content = content;
        detailsView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsView animated:YES];
}


@end
