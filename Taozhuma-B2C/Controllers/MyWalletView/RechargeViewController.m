//
//  RechargeViewController.m
//  Taozhuma-B2C
//  钱包充值
//  Created by edz on 17/2/15.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "RechargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface RechargeViewController ()<UITextFieldDelegate>{
    
}

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeSuccess) name:@"rechargeSuccess"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeFail) name:@"rechargeFail"object:nil];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:gesture];
    
    //默认为支付宝充值
    _payType = @"1";
    
    _money.delegate = self;
    _money.returnKeyType = UIReturnKeyDone;
    _money.keyboardType = UIKeyboardTypeNumberPad;
    _money.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)rechargeAction:(id)sender {
    NSLog(@"_payType:%@",_payType);
    if ([_payType isEqualToString:@"2"]) {
        /* 检测是否已安装微信 */
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请先安装微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alter show];
            return;
        }
    }
    
    // 1. URL
    NSString *path = [NSString stringWithFormat:@"/Api/Wallet/reCharge?"];
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVICE_URL,path]];
    
    // 2. 请求(可以改的请求)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // ? POST
    // 默认就是GET请求
    request.HTTPMethod = @"POST";
    // ? 数据体
    NSString *str = [NSString stringWithFormat:@"pay_type=%@&userId=%@&amount=%@", _payType, [Tools stringForKey:KEY_USER_ID],_money.text];
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
                
                NSDictionary *dic = [self dictionaryWithJsonString:str];
                NSString* statusMsg = [dic valueForKey:@"status"];
                if ([statusMsg intValue] == 201){
                    //获取成功，无数据情况
                    
                }else if ([statusMsg intValue] == 500){
                    //弹框提示获取失败
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"支付错误!";
                    hud.yOffset = -50.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:2];
                    return;
                    
                }else if ([statusMsg intValue] == 200){
                    //支付宝支付
                    NSString *payInfo = [[dic valueForKey:@"data"] valueForKey:@"Payinfo"];
                    if ([_payType isEqual:@"1"] && payInfo != nil) {
                        //应用注册scheme,在Info.plist定义URL types
                        NSString *appScheme = @"wx69b0d0dbc086b71f";
                        
                        // NOTE: 调用支付结果开始支付
                        [[AlipaySDK defaultService] payOrder:payInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            NSLog(@"reslut = %@",resultDic);
                            //将用户充值标示设置为true
                            [Tools saveBool:true forKey:KEY_RECHARGE_TAG];
                            //没有安装支付宝时调用网页版，回调功能
                            NSString *memo = [resultDic valueForKey:@"memo"];
                            NSString *resultStatus = [resultDic valueForKey:@"resultStatus"];
                            if ([resultStatus integerValue] == 9000) {
                                memo = @"支付成功";
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshByWalletDetail" object:nil];
                                //弹框提示充值成功
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                hud.mode = MBProgressHUDModeText;
                                hud.labelText = @"充值成功!";
                                hud.yOffset = -50.f;
                                hud.removeFromSuperViewOnHide = YES;
                                [hud hide:YES afterDelay:2];
                                
                                [self performSelector:@selector(backClick:) withObject:nil afterDelay:1];
                            }else{
                                memo = @"充值失败";
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshByWalletDetail" object:nil];
                                //弹框提示充值成功
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                hud.mode = MBProgressHUDModeText;
                                hud.labelText = @"充值失败!";
                                hud.yOffset = -50.f;
                                hud.removeFromSuperViewOnHide = YES;
                                [hud hide:YES afterDelay:1];
                                return ;
                            }
                        }];
                    }else if([_payType isEqual:@"2"]){
                        NSDictionary *wxDic = [dic valueForKey:@"data"];
                        PayReq *request = [[PayReq alloc] init];
                        /** 商家向财付通申请的商家id */
                        request.partnerId = [wxDic valueForKey:@"partnerid"];
                        /** 预支付订单 */
                        request.prepayId = [wxDic valueForKey:@"prepayid"];
                        /** 商家根据财付通文档填写的数据和签名 */
                        request.package = [wxDic valueForKey:@"package"];
                        /** 随机串，防重发 */
                        request.nonceStr= [wxDic valueForKey:@"noncestr"];
                        /** 时间戳，防重发 */
                        request.timeStamp= [[wxDic valueForKey:@"timestamp"] intValue];
                        /** 商家根据微信开放平台文档对数据做的签名 */
                        request.sign= [wxDic valueForKey:@"sign"];
                        /*! @brief 发送请求到微信，等待微信返回onResp
                         *
                         * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
                         * SendAuthReq、SendMessageToWXReq、PayReq等。
                         * @param req 具体的发送请求，在调用函数后，请自己释放。
                         * @return 成功返回YES，失败返回NO。
                         */
                        [WXApi sendReq: request];
                    }
                }

            }];
        }
    }];
    
    
}

//登陆成功跳转页面
- (IBAction)backClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMine" object:nil];
    // 返回上页
        [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)zfbAction:(id)sender {
    _zfbCheckBtn.image = [UIImage imageNamed:@"checkbox_active.png"];
    _wxCheckBtn.image = [UIImage imageNamed:@"checkbox.png"];
    _payType = @"1";
}

- (IBAction)wxAction:(id)sender {
    _zfbCheckBtn.image = [UIImage imageNamed:@"checkbox.png"];
    _wxCheckBtn.image = [UIImage imageNamed:@"checkbox_active.png"];
    _payType = @"2";
}

//隐藏键盘方法
-(void)hideKeyboard{
    [_money resignFirstResponder];
}

//弹框提示充值成功
-(void)rechargeSuccess{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshByWalletDetail" object:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"充值成功!";
    hud.yOffset = -50.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
    
    [self performSelector:@selector(backClick:) withObject:nil afterDelay:1];
}

//弹框提示充值成功
-(void)rechargeFail{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshByWalletDetail" object:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"充值失败!";
    hud.yOffset = -50.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
    [self performSelector:@selector(backClick:) withObject:nil afterDelay:1];
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
