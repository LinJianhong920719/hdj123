//
//  RegisterViewControllerNewViewController.m
//  Taozhuma-B2C
//
//  Created by Average on 16/7/25.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "RegisterViewControllerNew.h"
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewControllerNew (){
    UIImageView *loginBgImage;
    UIButton *loginButton;
}

@property (strong, nonatomic) UITextField *phoneField;
@property (strong, nonatomic) UITextField *checkField;
@property (strong, nonatomic) UIButton *btnToObtain;
@end

@implementation RegisterViewControllerNew
@synthesize phoneField;
@synthesize checkField;
@synthesize btnToObtain;
- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏
    [self hideNaviBar:YES];
    [self contentView];
}

-(void)contentView{
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
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [baseView addSubview:phoneField];
    
    //验证码输入框
    checkField = [[UITextField alloc]initWithFrame:CGRectMake(0.047*ScreenWidth, viewBottom(phoneField)+14, 0.43*ScreenWidth, 41)];
    [checkField setFont:[UIFont systemFontOfSize:14]];
    checkField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    //设置圆角
    checkField.layer.cornerRadius =5.0;
    checkField.borderStyle = UITextBorderStyleRoundedRect;
    checkField.delegate = self;
    checkField.keyboardType = UIKeyboardTypeNumberPad;
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
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"请输入正确的手机号码！";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//            return;
        }
    } else if (phoneField.text.length == 0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"请输入手机号码！";
//        hud.yOffset = -50.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:1];
//        return;
    }
    if (checkField.text.length == 0) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"请输入验证码！";
//        hud.yOffset = -50.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:2];
//        return;
    }

//     MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"正在登录...";
//    [hud show:YES];
    NSMutableArray *allLevel = [[NSMutableArray alloc]init];
    [allLevel removeAllObjects];

    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         phoneField.text,     @"phone",
                         @"check",       @"act",
                         @"e3dc653e2d68697346818dfc0b208322",       @"key",
                         checkField.text,       @"captcha",
                         nil];
    NSLog(@"%@",dic);
    NSString *xpoint = @"";
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
//隐藏键盘方法
-(void)hideKeyboard{
    [checkField resignFirstResponder];
}


@end
