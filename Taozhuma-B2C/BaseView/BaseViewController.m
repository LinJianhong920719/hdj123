//
//  BaseViewController.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController{
    
    UIView *workView;
    //自定义动画控件
    __weak UIImageView *_customImage;
}

@synthesize isBackToroot;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setNaviBarTitle:self.title];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    titleView.text = self.title;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.font = UIFontWithName(FontName_Default, 18.0f);
    titleView.textColor = [UIColor whiteColor];
    titleView.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = titleView;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    // 背景色设为白色
    self.view.backgroundColor = COLOR_F2F2F2;
    
    // 自定义loading...动画图片
    UIImageView *customImage = [[UIImageView alloc] init];
    customImage.contentMode = UIViewContentModeScaleAspectFit;
    customImage.image = [UIImage imageNamed:@"loading.png"];
    [self.view addSubview:_customImage = customImage];
    
    CGSize loadingSize = CGSizeMake(20, 20);
    _customImage.frame = CGRectMake((ScreenWidth-loadingSize.width)/2,(ScreenHeight-loadingSize.height)/2, loadingSize.width, loadingSize.height);
    
    //重新设置右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate=(id<UIGestureRecognizerDelegate>)self;
    
}

#pragma mark - 自定义刷新动画
#pragma mark 开始动画
- (void)startLoading
{
    //旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.6;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_customImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark 结束动画
- (void)endLoading
{
    [_customImage.layer removeAnimationForKey:@"rotationAnimation"];
    [_customImage removeFromSuperview];
}


#pragma mark 捕获动画开始时和终了时的事件
/**
 * 动画开始时
 */
- (void)animationDidStart:(CAAnimation *)theAnimation
{
    NSLog(@"begin");
}

/**
 * 动画结束时
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSLog(@"end");
}


/**
 * 没用网络时加载
 */
- (void)networkView {
    
    workView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewOrignY, ScreenWidth, ScreenHeight-ViewOrignY)];
    //    workView.hidden = YES;
    [workView setBackgroundColor:BGCOLOR_DEFAULT];
    [self.view addSubview:workView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading-2"]];
    imageView.frame = CGRectMake(0, (ScreenHeight - 350)/2, ScreenWidth, 130);
    imageView.backgroundColor = [UIColor redColor];
    [workView addSubview:imageView];
    
    UILabel *titile = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(imageView) + 20, ScreenWidth, 20)];
    titile.textColor = UIColorWithRGBA(181, 181, 182, 1);
    titile.font = UIFontWithName(FontName_Default, 13.0f);
    titile.textAlignment = NSTextAlignmentCenter;
    titile.text = @"点击屏幕,重新加载";
    [workView addSubview:titile];
    
    UIButton * loading = [UIButton buttonWithType:UIButtonTypeCustom];;
    loading.frame = workView.frame;
    [loading addTarget:self action:@selector(newloadDataClick:) forControlEvents:UIControlEventTouchUpInside];
    [workView addSubview:loading];
    
}

- (void)startNetwork {
    [self.view bringSubviewToFront:workView];
    workView.hidden = NO;
}

- (void)endNetwork {
    workView.hidden = YES;
}

//- (BOOL) isBlankString:(NSString *)string {
//    if (string == nil || string == NULL) {
//        return YES;
//    }
//    if ([string isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//
//    return NO;
//}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


- (void)pushViewControllerByUserLogin:(void(^)(void))finishBlock {
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([Tools boolForKey:USER_IS_LOGIN]) {
            finishBlock();
            NSLog(@"用户已登录");
        } else {
            NSLog(@"用户未登录");
        }
    });
    
}

#pragma mark -

//视图即将可见时调用。
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:_customImage];
    //    [self startLoading];
}

//视图已完全过渡到屏幕上时调用
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

//视图被解散时调用，覆盖或以其他方式隐藏。
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self endLoading];
}

//视图被解散后调用，覆盖或以其他方式隐藏。
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)showHUDText:(NSString *)text {
    
    if (text && text.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = text;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
    
}

@end
