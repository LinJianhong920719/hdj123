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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
