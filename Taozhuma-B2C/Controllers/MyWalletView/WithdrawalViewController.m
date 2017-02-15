//
//  WithdrawalViewController.m
//  Taozhuma-B2C
//
//  Created by edz on 17/2/13.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "WithdrawalViewController.h"

@interface WithdrawalViewController ()<UITextFieldDelegate>{
    UIAlertView *alert;
}

@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:gesture];
    
    _zfbAccount.delegate = self;
    _zfbAccount.returnKeyType = UIReturnKeyNext;
    _zfbAccount.keyboardType = UIKeyboardTypeDefault;
    _zfbAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_zfbAccount addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _money.delegate = self;
    _money.returnKeyType = UIReturnKeyDone;
    _money.keyboardType = UIKeyboardTypeNumberPad;
    _money.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)withdrawAction:(id)sender {
    if (_zfbAccount.text.length == 0) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"支付宝账号不允许为空" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (_money.text.length == 0) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"提现金额不允许为空" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_money.text integerValue] <= 50) {
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"提现金额不允许低于50元" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // 1. URL
    NSString *path = [NSString stringWithFormat:@"/Api/Wallet/getCash?"];
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVICE_URL,path]];
    
    // 2. 请求(可以改的请求)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // ? POST
    // 默认就是GET请求
    request.HTTPMethod = @"POST";
    // ? 数据体
    NSString *str = [NSString stringWithFormat:@"amount=%@&userId=%@&account=%@", _zfbAccount.text, [Tools stringForKey:KEY_USER_ID],_money.text];
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
                [self hideKeyboard];
                alert=[[UIAlertView alloc]initWithTitle:nil message:@"您的提现申请以提交,我们会在5个工作日内完成您的提现操作。" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
                
                [self performSelector:@selector(backClick:) withObject:nil afterDelay:1];
                
            }];
        }
    }];
    
}

// 返回上页
- (IBAction)backClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    if (sender == _zfbAccount) {
        [_money becomeFirstResponder];
    }else if (sender == _money) {
        [self hideKeyboard];
    }
}

//隐藏键盘方法
-(void)hideKeyboard{
    [_zfbAccount resignFirstResponder];
    [_money resignFirstResponder];
}
@end
