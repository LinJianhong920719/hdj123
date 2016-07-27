//
//  TabBarController.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/5.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "TabBarController.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "JTNavigationController.h"
#import "AppConfig.h"
#import "MineViewControllers.h"
#import "MyCartViewController.h"

#define Main_TabBarHeight 50

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initMainView];
}

- (void)initMainView {
    
    [Tools saveInteger:1 forKey:KEY_TabBarNum];

    MainViewController *firstVC = [[MainViewController alloc] init];
    UITabBarItem *firstItem = [[UITabBarItem alloc] initWithTitle:nil image:[self imageWithImageName:@"Home_Normal"] selectedImage:[self imageWithImageName:@"Home_Normal_S"]];
    firstItem.tag = 1;
    firstVC.tabBarItem = firstItem;
    JTNavigationController *firstNav = [[JTNavigationController alloc] initWithRootViewController:firstVC];
    
    ViewController *secondVC = [[ViewController alloc] init];
    secondVC.title = @"分类";
    UITabBarItem *secondItem = [[UITabBarItem alloc] initWithTitle:nil image:[self imageWithImageName:@"Classification_Normal"] selectedImage:[self imageWithImageName:@"Classification_Normal_S"]];
    secondItem.tag = 2;
    secondVC.tabBarItem = secondItem;
    JTNavigationController *secondNav = [[JTNavigationController alloc] initWithRootViewController:secondVC];
    
//    ViewController *thirdVC = [[ViewController alloc] init];
//    thirdVC.title = @"TV";
//    UITabBarItem *thirdItem = [[UITabBarItem alloc] initWithTitle:nil image:[self imageWithImageName:@"TV_Normal"] selectedImage:[self imageWithImageName:@"TV_Normal_S"]];
//    thirdItem.tag = 3;
//    thirdVC.tabBarItem = thirdItem;
//    JTNavigationController *thirdNav = [[JTNavigationController alloc] initWithRootViewController:thirdVC];
    
    MyCartViewController *fourthVC = [[MyCartViewController alloc] init];
    fourthVC.title = @"购物车";
    UITabBarItem *fourthItem = [[UITabBarItem alloc] initWithTitle:nil image:[self imageWithImageName:@"Cart_Normal"] selectedImage:[self imageWithImageName:@"Cart_Normal_S"]];
    fourthItem.tag = 4;
    fourthVC.tabBarItem = fourthItem;
    JTNavigationController *fourthNav = [[JTNavigationController alloc] initWithRootViewController:fourthVC];
    
    MineViewControllers *fifthVC = [[MineViewControllers alloc] init];
    fifthVC.title = @"我的";
    UITabBarItem *fifthItem = [[UITabBarItem alloc] initWithTitle:nil image:[self imageWithImageName:@"Mine_Normal"] selectedImage:[self imageWithImageName:@"Mine_Normal_S"]];
    fifthItem.tag = 5;
    fifthVC.tabBarItem = fifthItem;
    JTNavigationController *fifthNav = [[JTNavigationController alloc] initWithRootViewController:fifthVC];
    
    self.viewControllers = @[firstNav, secondNav, fourthNav, fifthNav];


}


- (UIImage *)imageWithImageName:(NSString *)imageName {

    //图片尺寸
    CGSize imageSize = CGSizeMake(76, 50);
    
    UIImage *image = [self imageWithImageSimple:[UIImage imageNamed:imageName] scaledToSize:imageSize];
    
    return image;
}

- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {

    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    //UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    
    [image drawInRect:CGRectMake(0, 6, newSize.width, newSize.height)];//根据新的尺寸画出传过来的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    
    newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIGraphicsEndImageContext();//关闭当前环境
    
    return newImage;
    
}

- (void)tabBar:(UITabBar *)tabBar2 didSelectItem:(UITabBarItem *)Item {
  
    
    [Tools saveInteger:Item.tag forKey:KEY_TabBarNum];
    [[NSNotificationCenter defaultCenter] postNotificationName:TabBarIndex_Change object:nil];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {

}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {

}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {

}

- (void)viewWillLayoutSubviews {
    
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = Main_TabBarHeight;
    tabFrame.origin.y = self.view.frame.size.height - Main_TabBarHeight;
    self.tabBar.frame = tabFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
