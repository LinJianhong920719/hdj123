//
//  RegisterViewControllerNewViewController.m
//  Taozhuma-B2C
//
//  Created by Average on 16/7/25.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "RegisterViewControllerNew.h"
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewControllerNew ()<UIActionSheetDelegate,UITextFieldDelegate>{
    UIImageView *loginBgImage;
    UIButton *loginButton;
    UITextField *phoneField;
    UITextField *checkField;
    NSInteger secongsCount;
    NSTimer *countTimer;

}


@property (strong, nonatomic) UIButton *btnToObtain;
@end

@implementation RegisterViewControllerNew

@synthesize btnToObtain;
- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏
    [self hideNaviBar:YES];
    [self contentView];
}

-(void)contentView{
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:gesture];
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"login_bg.png"]];
    [baseView setBackgroundColor:bgColor];
    [self.view addSubview:baseView];
    
    loginBgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.275*ScreenWidth, 0.16*ScreenHeight, 0.45*ScreenWidth, 83*(0.45*ScreenWidth/144))];
    [loginBgImage setImage:[UIImage imageNamed:@"login_logo.png"]];
    [baseView addSubview:loginBgImage];
    
    //手机号码输入框
    phoneField = [[UITextField alloc]initWithFrame:CGRectMake(0.047*ScreenWidth, viewBottom(loginBgImage)+36, 0.91*ScreenWidth, 41)];
    phoneField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    [phoneField setFont:[UIFont systemFontOfSize:14]];
    //设置圆角
    phoneField.layer.cornerRadius =5.0;
    phoneField.borderStyle = UITextBorderStyleRoundedRect;
    phoneField.placeholder = @"  请输入位手机号码";
    phoneField.delegate = self;
    phoneField.returnKeyType = UIReturnKeyNext;
    phoneField.keyboardType = UIKeyboardTypeDefault;
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:phoneField];
    
    //验证码输入框
    checkField = [[UITextField alloc]initWithFrame:CGRectMake(0.047*ScreenWidth, viewBottom(phoneField)+14, 0.43*ScreenWidth, 41)];
    [checkField setFont:[UIFont systemFontOfSize:14]];
    checkField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    //设置圆角
    checkField.layer.cornerRadius =5.0;
    checkField.borderStyle = UITextBorderStyleRoundedRect;
    checkField.delegate = self;
    checkField.keyboardType = UIKeyboardTypeDefault;
    checkField.returnKeyType = UIReturnKeyDone;
    checkField.clearButtonMode = UITextFieldViewModeWhileEditing;
    checkField.placeholder = @"  输入验证码";
    [checkField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:checkField];
    
    //获取验证码按钮
    btnToObtain = [UIButton buttonWithType:UIButtonTypeCustom];
    btnToObtain.layer.cornerRadius = 8;
    btnToObtain.frame = CGRectMake(viewRight(checkField)+10, viewBottom(phoneField)+14, 0.43*ScreenWidth, 41);
    
    [btnToObtain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnToObtain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnToObtain.titleLabel.font = [UIFont systemFontOfSize: 14];
    btnToObtain.backgroundColor = [UIColor colorWithRed:255/255.0f green:214/255.0f blue:0/255.0f alpha:1];
    [btnToObtain addTarget:self action:@selector(checkCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btnToObtain];
    
    // 登录按钮
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor=[UIColor colorWithRed:255/255.0f green:214/255.0f blue:0/255.0f alpha:1];
    loginButton.frame = CGRectMake(0.047*ScreenWidth, viewBottom(btnToObtain)+15, 0.91*ScreenWidth, 41);
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    loginButton.layer.cornerRadius = 5;
    [loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0.4125*ScreenWidth, viewBottom(loginButton)+0.287*ScreenHeight, 56, 11)];
    [backButton setTitle:@"<<再逛逛" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:12];
    backButton.titleLabel.textColor = [UIColor blackColor];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:backButton];
    
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//登陆成功跳转页面
- (IBAction)backClick:(id)sender {
    
    // 返回上页
    //        if (isBackToroot) {
    if(true){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//登陆
//13612412490   7878
- (void)loginClicked:(id)sender {
    
    [checkField resignFirstResponder];
    
    
    if (phoneField.text.length > 0) {
        if ([Tools isValidateMobile:phoneField.text] == NO) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入正确的手机号码！";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }
    } else if (phoneField.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入手机号码！";
        hud.yOffset = -50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return;
    }
    if (checkField.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入验证码！";
        hud.yOffset = -50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;
    }
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在登录...";
    [hud show:YES];
    
    NSMutableArray *allLevel = [[NSMutableArray alloc]init];
    [allLevel removeAllObjects];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         phoneField.text,     @"phone",
                         checkField.text,       @"code",
                         nil];
    NSLog(@"%@",dic);
    NSString *xpoint = @"/Api/User/login";
    [HYBNetworking postWithUrl:xpoint  refreshCache:YES emphasis:NO params:nil success:^(id response) {
        [HYBNetworking response:response success:^(id result, NSString *success_msg) {
            
            for (NSDictionary *temDic in result) {
                
                NSMutableArray *subArray = [[NSMutableArray alloc]init];
                [subArray removeAllObjects];
                
                for (NSDictionary *dic in [temDic valueForKey:@"type"]) {
                    
                    NSString *images = [dic valueForKey:@"image"];
                    if (!images) {
                        images = @"";
                    }
                    NSDictionary *subClass = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"id"], @"id", images, @"image", [dic valueForKey:@"name"], @"name", nil];
                    
                    [subArray addObject:subClass];
                }
                
                NSString *image = [temDic valueForKey:@"image"];
                if (!image) {
                    image = @"";
                }
                
                NSDictionary *dicLevel1 = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", [temDic valueForKey:@"name"], @"name", subArray, @"type", nil];
                
                [allLevel addObject:dicLevel1];
            }
            
            [Tools saveObject:allLevel forKey:SaveData_Classification];
            
        } fail:^(NSString *error_msg) {
            
        }];
    } fail:^(NSError *error) {
        
    }];}

//获取验证码
- (IBAction)checkCodeClick:(id)sender {
    
    //关闭键盘
    [phoneField resignFirstResponder];
    //获取用户输入的手机号码
    NSString *phone = phoneField.text;
    //将手机号码保存到tools中
    [Tools saveObject:phone forKey:KEY_USER_PHONE];
    //用户输入的手机号码长度不为零
    if (phone.length > 0) {
        //如果手机号码格式不正确
        if ([Tools isValidateMobile:phone] == NO) {
            //弹框提示手机号码不正确
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入正确的手机号码!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }
    //用户输入的手机号码长度为零
    } else if (phone.length == 0) {
        //弹框提示请输入手机号码
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入手机号码!";
        hud.yOffset = -50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;
    }
    //全部正确提示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"验证短信发送中...";
    [hud show:YES];
    
    //接口调用
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         phone,     @"phone",
                         [Tools stringForKey:TokenDatas],     @"token",
                         nil];
    NSLog(@"%@",dic);
    NSString *xpoint = @"/Api/User/getCode?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dic success:^(id response) {
        //获取接口返回的数据
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        if([statusMsg intValue] == 4001){
            NSLog(@"Msg is null");
            AppDelegate *ade = [[AppDelegate alloc] init];
            [ade getTokenMessage];
        }else{
            [hud removeFromSuperview];
            
            if ([statusMsg intValue] == 200) {
                //重发倒计时
                secongsCount = 60;
                countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"验证短信发送成功";
                hud.yOffset = -50.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabelText = @"error";
                hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
                hud.yOffset = -50.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
            }
        }
          
    } fail:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"验证短信发送失败，请重试";
        hud.yOffset = -50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        
    }];
}

-(void)timerFireMethod {
    secongsCount--;
    if (secongsCount==0) {
        [countTimer invalidate];
        [btnToObtain setUserInteractionEnabled:YES];
        [btnToObtain setTitle: @"获取验证码" forState: UIControlStateNormal];
        btnToObtain.backgroundColor = [UIColor colorWithRed:255/255.0f green:214/255.0f blue:0/255.0f alpha:1];
        [btnToObtain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [btnToObtain setUserInteractionEnabled:NO];
        [btnToObtain setTitle: [NSString stringWithFormat:@"%d秒",secongsCount] forState: UIControlStateNormal];
        btnToObtain.backgroundColor = [UIColor grayColor];
        [btnToObtain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

//隐藏键盘方法
-(void)hideKeyboard{
    [phoneField resignFirstResponder];
    [checkField resignFirstResponder];
}
//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    if (sender == phoneField) {
        [checkField becomeFirstResponder];
    } else if (sender == checkField) {
        [self hideKeyboard];
    }
}

@end
