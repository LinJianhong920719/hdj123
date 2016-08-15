//
//  RegisteredViewController.m
//  注册(无用)
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//


#import "RegisteredViewController.h"

#import "EMAsyncImageView.h"


@interface RegisteredViewController () <UIActionSheetDelegate>{
    UIView *fieldImageView;
    NSInteger secongsCount;
    NSTimer *countTimer;
    NSString *passWord;
    UIButton *loginButton;
}
@property (strong, nonatomic) UITextField *phoneField;
@property (strong, nonatomic) UITextField *checkField;
@property (strong, nonatomic) UIButton *btnToObtain;
@property (nonatomic, strong) NSString *captcha;
@end

@implementation RegisteredViewController
@synthesize phoneField;
@synthesize checkField;
@synthesize btnToObtain;
@synthesize captcha;
@synthesize isBackToroot;
- (void)viewDidLoad {
    //接受通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refreshMyWalletPassWord"object:nil];
    [super viewDidLoad];
    [self fieldView];
    
}

- (void)fieldView {
    fieldImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, DEVICE_SCREEN_SIZE_WIDTH, 86)];
    fieldImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fieldImageView];
    
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PROPORTION414*20, 10, 20, 20)];
    [phoneImageView setImage:[UIImage imageNamed:@"wm-081"]];
    [fieldImageView addSubview:phoneImageView];
    
    //手机号码输入框
    phoneField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(phoneImageView)+15, 5, DEVICE_SCREEN_SIZE_WIDTH-viewRight(phoneImageView)-20, 30)];
    [phoneField setFont:[UIFont systemFontOfSize:14]];
    phoneField.placeholder = @"请输入11位手机号码";
    phoneField.delegate = self;
    phoneField.returnKeyType = UIReturnKeyNext;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldImageView addSubview:phoneField];
    [phoneField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //分割线
    EMAsyncImageView *line = [[EMAsyncImageView alloc]initWithFrame:CGRectMake(0, viewBottom(phoneField)+5, DEVICE_SCREEN_SIZE_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:238/255.0f green:239/255.0f blue:239/255.0f alpha:1];
    [fieldImageView addSubview:line];
    
    
    UIImageView *checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(PROPORTION414*20, viewBottom(line)+10, 20, 20)];
    [checkImageView setImage:[UIImage imageNamed:@"wm-082"]];
    [fieldImageView addSubview:checkImageView];
    
    //验证码输入框
    checkField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(checkImageView)+15, viewBottom(line)+5, DEVICE_SCREEN_SIZE_WIDTH-viewRight(checkImageView)-110, 30)];
    [checkField setFont:[UIFont systemFontOfSize:14]];
    checkField.delegate = self;
    checkField.keyboardType = UIKeyboardTypeNumberPad;
    checkField.returnKeyType = UIReturnKeyDone;
    checkField.clearButtonMode = UITextFieldViewModeWhileEditing;
    checkField.placeholder = @"输入验证码";
    [fieldImageView addSubview:checkField];
    [checkField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //获取验证码按钮
    btnToObtain = [UIButton buttonWithType:UIButtonTypeCustom];
    btnToObtain.layer.cornerRadius = 8;
    btnToObtain.frame = CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-90, viewBottom(line)+8, 80, 30);
    
    [btnToObtain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnToObtain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnToObtain.titleLabel.font = [UIFont systemFontOfSize: 12];
    btnToObtain.backgroundColor = [UIColor colorWithRed:234/255.0f green:22/255.0f blue:175/255.0f alpha:1];    
    [btnToObtain addTarget:self action:@selector(checkCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [fieldImageView addSubview:btnToObtain];
    UILabel *voiceNoise = [[UILabel alloc]initWithFrame:CGRectMake(20, viewBottom(fieldImageView)+10, DEVICE_SCREEN_SIZE_WIDTH, 20)];
    voiceNoise.textColor = [UIColor colorWithRed:51/255.0f green:161/255.0f blue:201/255.0f alpha:1];
    voiceNoise.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:voiceNoise];
    
    // 登录按钮
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor=[UIColor colorWithRed:234/255.0f green:22/255.0f blue:175/255.0f alpha:1];
    loginButton.frame = CGRectMake(PROPORTION414*15, viewBottom(voiceNoise)+20, PROPORTION414*381, 42);
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    loginButton.layer.cornerRadius = 5;
    [loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
}


////登陆
////13612412490   7878
//- (void)loginClicked:(id)sender {
//    
//    [checkField resignFirstResponder];
//    
//    
//    if (phoneField.text.length > 0) {
//        if ([Tools isValidateMobile:phoneField.text] == NO) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"请输入正确的手机号码！";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//            return;
//        }
//    } else if (phoneField.text.length == 0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"请输入手机号码！";
//        hud.yOffset = -50.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:1];
//        return;
//    }
//    if (checkField.text.length == 0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"请输入验证码！";
//        hud.yOffset = -50.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:2];
//        return;
//    }
//    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"正在登录...";
//    [HUD show:YES];
//    
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         phoneField.text,     @"phone",
//                         @"check",       @"act",
//                         @"e3dc653e2d68697346818dfc0b208322",       @"key",
//                         checkField.text,       @"captcha",
//                         [Tools stringForKey:KEY_BAIDU_ID],       @"device_id",
//                         nil];
//    NSLog(@"%@",dic);
//    NSString *xpoint = USERXPOINT;
//    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        
//        if (error) {
//            [HUD removeFromSuperview];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:NO afterDelay:2];
//        } else {
//            [HUD removeFromSuperview];
//            if (respond.result == YES) {
//                
//
//                
//                    
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.labelText = @"登录成功";
//                    hud.yOffset = -50.f;
//                    hud.removeFromSuperViewOnHide = YES;
//                    [hud hide:YES afterDelay:2];
//                
//                
//                    NSString *userid = [respond.respondData valueForKey:@"uid"];
//                    NSString *nikeName = [respond.respondData valueForKey:@"nikename"];
//                    NSString *level = [respond.respondData valueForKey:@"level"];
//                    NSString *head_icon = [respond.respondData valueForKey:@"head_icon"];
//                    NSString *cardnum = [respond.respondData valueForKey:@"cardnum"];
//                    NSString *amount = [respond.respondData valueForKey:@"amount"];
//                    [Tools saveObject:level forKey:KEY_USER_TYPE];
//                    [Tools saveObject:userid forKey:KEY_USER_ID];
//                    [Tools saveObject:nikeName forKey:KEY_NIKE_NAME];
//                    [Tools saveObject:phoneField.text forKey:KEY_USER_PHONE];
//                    [Tools saveObject:level forKey:KEY_LEVEL];
//                    [Tools saveObject:head_icon forKey:KEY_HEAD_ICON];
//                    [Tools saveObject:cardnum forKey:KEY_CARDNUM];
//                    [Tools saveObject:amount forKey:KEY_AMOUNT];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
//                    [Tools saveBool:YES forKey:KEY_IS_LOGIN];
//                    [self performSelector:@selector(backClick:) withObject:nil afterDelay:0.5];
//
//
//                
//            } else {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.detailsLabelText = respond.error_msg;
//                hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
//                hud.yOffset = -50.f;
//                hud.removeFromSuperViewOnHide = YES;
//                
//                [hud hide:YES afterDelay:2];
//            }
//        }
//    }];
//}

//-(void)timerFireMethod {
//    secongsCount--;
//    if (secongsCount==0) {
//        [countTimer invalidate];
//        [btnToObtain setUserInteractionEnabled:YES];
//        [btnToObtain setTitle: @"获取验证码" forState: UIControlStateNormal];
//        btnToObtain.backgroundColor = [UIColor colorWithRed:234/255.0f green:22/255.0f blue:175/255.0f alpha:1];
//        [btnToObtain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    } else {
//        [btnToObtain setUserInteractionEnabled:NO];
//        [btnToObtain setTitle: [NSString stringWithFormat:@"%d秒",secongsCount] forState: UIControlStateNormal];
//        btnToObtain.backgroundColor = [UIColor grayColor];
//        [btnToObtain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
//}
//
////登陆成功跳转页面
//- (IBAction)backClick:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMine" object:nil];
//    // 返回上页
// 
//        
//        if (isBackToroot) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//        else {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//
//    
//}
//
////获取验证码
//- (IBAction)checkCodeClick:(id)sender {
//    
//    //关闭键盘
//    [phoneField resignFirstResponder];
//    
//    NSString *phone = phoneField.text;
//    [Tools saveObject:phone forKey:KEY_USER_PHONE];
//    
//    if (phone.length > 0) {
//        if ([Tools isValidateMobile:phone] == NO) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"请输入正确的手机号码!";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//            return;
//        }
//    } else if (phone.length == 0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"请输入手机号码!";
//        hud.yOffset = -50.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:2];
//        return;
//    }
//    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"验证短信发送中...";
//    [HUD show:YES];
//    
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         phone,     @"phone",
//                         @"1",     @"source",
//                         @"e3dc653e2d68697346818dfc0b208322",     @"key",
//                         nil];
//    NSLog(@"%@",dic);
//    NSString *xpoint = CAPTCHAXPOINT;
//    [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
//        if (error) {
//            [HUD removeFromSuperview];
//            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"验证短信发送失败，请重试";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//        } else {
//            [HUD removeFromSuperview];
//            
//            if (respond.result == YES) {
//                //重发倒计时
//                secongsCount = 60;
//                countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
//                
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"验证短信发送成功";
//                hud.yOffset = -50.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//                self.captcha = [respond.respondData valueForKey:@"captcha"];
//                [Tools saveObject:phone forKey:KEY_USER_PHONE];
//            } else {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.detailsLabelText = respond.error_msg;
//                hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
//                hud.yOffset = -50.f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
//            }
//        }
//    }];
//}
- (void)loadData {
    
}
//隐藏键盘方法
-(void)hideKeyboard{
    [checkField resignFirstResponder];
}
//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    if (sender == checkField) {
        [self hideKeyboard];
        if(checkField.text.length > 0 ){
            loginButton.backgroundColor=[UIColor colorWithRed:234/255.0f green:22/255.0f blue:175/255.0f alpha:1];
        }
    }
    
}
@end
