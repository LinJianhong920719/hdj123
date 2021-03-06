//
//  SearchViewController.m
//  搜索
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//


#import "SearchViewController.h"
#import "RegisterViewControllerNew.h"

#define RecordCount 8      //最多存储5条，自定义
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SearchHistory"]
@interface SearchViewController ()  {
    NSArray *_data;
    NSArray *historyArray;
    NSMutableArray *hotArray;
    
    UIView *topView;
    UIButton *but;
    UITextField *searchLabel;
    UIView *baseView;
    UIView *backView;
    UIImageView *line;
}


@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //隐藏导航栏
    [self hideNaviBar:YES];
    
    
    
    hotArray = [[NSMutableArray alloc]init];

    //初始化UI视图
    [self initTopNav];
    
    //获取热门搜索信息
    [self getHotSearchList];
    
    [self historySearchView];
    
    
    
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
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(searchLabel)+10, 25, 40, 35)];
    [backBut setImageEdgeInsets:UIEdgeInsetsMake(3, 0, 3, 0) ];//将按钮的上左下右都缩进
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
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(topView), ScreenWidth, ScreenHeight-topView.frame.size.height)];
    backView.backgroundColor = BGCOLOR_DEFAULT;
    [self.view addSubview:backView];
    
}
#pragma mark -- 搜索历史View
-(void)historySearchView{
    //搜索历史
    UIView *historySearchView = [[UIView alloc]init];
    //设置搜索历史
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    historyArray = [userDefaultes arrayForKey:@"SearchHistory"];
    
    if([historyArray count] == 0){
        [historySearchView setFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    }else if([historyArray count] >0 && [historyArray count] <5){
        [historySearchView setFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    }
    else{
        [historySearchView setFrame:CGRectMake(0, 0, ScreenWidth, 109)];
    }
    
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
    
    int width1 = 0;
    int height1 = 0;
    int number1 = 0;
    int han1 = 0;
    
    
    //创建button
    for (int i = 0; i < historyArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 300 + i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        CGSize titleSize = [self getSizeByString:historyArray[i] AndFontSize:10.0];
        han1 = han1 +titleSize.width+10;
        if (han1 > ScreenWidth) {
            han1 = 0;
            han1 = han1 + titleSize.width;
            height1++;
            width1 = 0;
            width1 = width1+titleSize.width;
            number1 = 0;
            button.frame = CGRectMake(10, 35*height1+viewBottom(sLabel)+10, titleSize.width, 25);
        }else{
            button.frame = CGRectMake(width1+10+(number1*10), 35*height1+viewBottom(sLabel)+10, titleSize.width, 25);
            width1 = width1+titleSize.width;
        }
        number1++;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setTitleColor:FONTS_COLOR153 forState:UIControlStateNormal];
        [button setTitle:historyArray[i] forState:UIControlStateNormal];
        [button.layer setBorderWidth:0.5]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 153, 153, 153, 1 });
        
        [button.layer setBorderColor:colorref];//边框颜色
        [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [historySearchView addSubview:button];
        NSLog(@"dd:%f",button.frame.origin.y+10);
        [historySearchView setFrame:CGRectMake(0, 0, ScreenWidth, button.frame.origin.y+35)];
    }
    
    
    [backView addSubview:historySearchView];
    
    line = [[UIImageView alloc]initWithFrame:CGRectMake(20, viewBottom(historySearchView)+5, ScreenWidth-40, 1)];
    line.backgroundColor = LINECOLOR_DEFAULT;
    [backView addSubview:line];
}

#pragma mark -- 热门搜索View
-(void)hotSearchView{
    //热门搜索
    UIView *hotSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(line), ScreenWidth, 129)];
    
    UIImageView *hImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 12, 12)];
    [hImage setImage:[UIImage imageNamed:@"search_hot"]];
    [hotSearchView addSubview:hImage];
    
    UILabel *hLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewRight(hImage)+5, 20, 100, 13)];
    hLabel.font =[UIFont systemFontOfSize:12];
    hLabel.textColor = [UIColor redColor];
    hLabel.text = @"热门搜索";
    [hotSearchView addSubview:hLabel];
    
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    
    NSArray *titleArr = hotArray;
    //创建button
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 300 + i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        CGSize titleSize = [self getSizeByString:titleArr[i] AndFontSize:10.0];
        han = han +titleSize.width+10;
        if (han > ScreenWidth) {
            han = 0;
            han = han + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(10, 35*height+viewBottom(hLabel)+10, titleSize.width, 25);
        }else{
            button.frame = CGRectMake(width+10+(number*10), 35*height+viewBottom(hLabel)+10, titleSize.width, 25);
            width = width+titleSize.width;
        }
        number++;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setTitleColor:FONTS_COLOR153 forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button.layer setBorderWidth:0.5]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 153, 153, 153, 1 });
        
        [button.layer setBorderColor:colorref];//边框颜色
        [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [hotSearchView addSubview:button];
    }
    
    
    [backView addSubview:hotSearchView];
}

#pragma mark -- 尚未登录View
-(void)noLoginView{
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    baseView.backgroundColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:0.3];

    [self.view addSubview:baseView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30*PROPORTION, 186*PROPORTION, 260*PROPORTION, 204*PROPORTION)];
    [imageView setImage:[UIImage imageNamed:@"loginMsg"]];
    imageView.userInteractionEnabled = YES;
    [baseView addSubview: imageView];
    
    UIButton *goBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 204*PROPORTION-41*PROPORTION, 130*PROPORTION, 40)];
    goBtn.backgroundColor = [UIColor clearColor];
    goBtn.tag = 10001;
    [goBtn addTarget:self action:@selector(noLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:goBtn];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewRight(goBtn), 204*PROPORTION-41*PROPORTION, 130*PROPORTION, 40)];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.tag = 10002;
    [loginBtn addTarget:self action:@selector(noLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:loginBtn];
}

- (IBAction)noLoginClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10001) {
        baseView.hidden = YES;
    }else if (btn.tag == 10002){
        baseView.hidden = YES;
        RegisterViewControllerNew *registeredView = [[RegisterViewControllerNew alloc]init];
        registeredView.title = @"快捷登陆";
        registeredView.hidesBottomBarWhenPushed = YES;
        registeredView.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:registeredView animated:YES];
    }
    
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
    if ([Tools boolForKey:KEY_IS_LOGIN]== YES) {
        [self toSearchProductList:btn.titleLabel.text];
    }else{
        [self noLoginView];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    switch (buttonIndex) {
        case 0: //"取消"按钮触发事件
            break;
        case 1://“清除”按钮触发事件
            //清除SearchHistory中的数据
            [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]init] forKey:@"SearchHistory"];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
            [hotArray removeAllObjects];
            for(NSDictionary *hotSearch in [dic valueForKey:@"data"]){
                NSLog(@"keyword:%@",[hotSearch valueForKey:@"keyword"]);
                
                [hotArray addObject:[hotSearch valueForKey:@"keyword"]];
                [self hotSearchView];
            }
            
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
        if ([Tools boolForKey:KEY_IS_LOGIN]== YES) {
            
            [self toSearchProductList:searchLabel.text];
        }else{
            [self noLoginView];
        }
        
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
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 5;
    return size;
}

@end
