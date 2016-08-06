//
//  AppDelegate.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/5.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfig.h"
#import "TabBarController.h"
#import "JTBaseNavigationController.h"
#import "AFNetworkReachabilityManager.h"
#import "GuideManager.h"
#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import <AdSupport/AdSupport.h>

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000

@interface AppDelegate ()

@property (nonatomic, strong) JTBaseNavigationController *mainNavigationController;
@property (nonatomic, strong) UITabBarController *mainTabBarController;

@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[JTBaseNavigationController alloc] initWithRootViewController:[[TabBarController alloc] init]];
    
    [JTBaseNavigationController shareNavgationController].fullScreenPopGestureEnable = YES; //开启全屏返回手势
    
    [JTBaseNavigationController shareNavgationController].backButtonImage = [UIImage imageNamed:@"backImage"]; //设置返回按钮图片
    
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    //获取idfa
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (idfa) {
        [Tools saveObject:idfa forKey:IDFA];
    } else {
        if (![Tools stringForKey:IDFA]) {
            [Tools saveObject:@"" forKey:IDFA];
        }
    }
    
    // 启动引导图
    [self guideManager];
    
    // 友盟分析
    [self umeng_Analytics];
    // 友盟推送
    [self umeng_Message:launchOptions];
    // 友盟第三方登录
    [self umeng_LoginQuick];
    
    // 配置网络访问参数
    [self configNetworking];
    //网络状态监控
    [self networkChanged];
    
    


    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, global_quque, ^{
        // 获取分类数据
        [self loadClassificationData];
    });
    
    dispatch_group_async(group, global_quque, ^{
        // 获取物流公司数据
        [self loadLogisticsCompanyData];
    });
    
    dispatch_group_notify(group, main_queue, ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
        NSLog(@"主线程");
    });
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)@"CFBundleShortVersionString"];
    NSString *buildstr = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)@"CFBundleVersion"];
    
    NSLog(@"version == %s", [version UTF8String]);
    NSLog(@"buildstr == %s", [buildstr UTF8String]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];

    [Tools saveObject:token forKey:DeviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
}

// ----------------------------------------------------------------------------------------
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
// ----------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

#pragma mark - 引导图

- (void)guideManager {
    
    NSMutableArray *paths = [NSMutableArray new];
    
    int introViewCount = 4;
    NSString *imageName;
    
    for (int i = 1; i <= introViewCount; i++) {
        imageName = [NSString stringWithFormat:@"Intro%d-%d", i, (int)[[UIScreen mainScreen] bounds].size.height];
        [paths addObject:[[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"]];
    }
    
    [[GuideManager shared] showGuideViewWithImages:paths];
    
}

#pragma mark - 友盟
#pragma mark (分析)

- (void)umeng_Analytics {
    
//    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    
    [MobClick setAppVersion:XcodeAppVersion];
    
    [MobClick startWithAppkey:UmengAppkey reportPolicy:BATCH  channelId:UMENG_CHANNEL_ID];
    
    //[MobClick checkUpdate];   //自动更新检查
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)notification {
    NSLog(@"online config has fininshed and params = %@", notification.userInfo);
}

#pragma mark (推送)

- (void)umeng_Message:(NSDictionary *)launchOptions {
    
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UmengAppkey launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    
}

#pragma mark (快速登录)

- (void)umeng_LoginQuick {

    [UMSocialData setAppKey:UmengAppkey];

    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAppId
                            appSecret:WXAppSecret
                                  url:@"http://www.umeng.com/social"];
    
    // 打开新浪微博的SSO开关
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppKey
                                              secret:SinaAppSecret
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //隐藏指定没有安装客户端的平台
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline,UMShareToSina]];

}


#pragma mark - TalkingData

- (void)configTalkingData {
    // App ID: 在 App Analytics 创建应用后，进入数据报表页中，在“系统设置”-“编辑应用”页面里查看App ID。
    // 渠道 ID: 是渠道标识符，可通过不同渠道单独追踪数据。
    [TalkingData sessionStarted:TalkingData_Appkey withChannelId:TALKINGDATA_CHANNEL_ID];
    
}

#pragma mark - 网络访问参数

- (void)configNetworking {
    
    // 网络请求接口
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    // 打印信息
    [HYBNetworking enableInterfaceDebug:YES];
    // 设置GET、POST请求都缓存
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];
    
}

#pragma mark - 网络状态监控

- (void)networkChanged {
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.35 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        //创建网络监听管理者对象
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        
        /*
         typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
         AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
         AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
         AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
         AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
         };
         */
        //设置监听
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未识别的网络");
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"不可达的网络(未连接)");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"2G,3G,4G...的网络");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"wifi的网络");
                    break;
                default:
                    break;
            }
        }];
        //开始监听
        [manager startMonitoring];
    
    });
    
}



#pragma mark - 获取分类数据

- (void)loadClassificationData {
    
    NSMutableArray *allLevel = [[NSMutableArray alloc]init];
    [allLevel removeAllObjects];
    
    NSString *path = [NSString stringWithFormat:@"productType.do?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking postWithUrl:path refreshCache:YES emphasis:NO params:nil success:^(id response) {
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
        
    }];
    
}

#pragma mark - 获取物流公司数据

- (void)loadLogisticsCompanyData {
    
    NSString *path = [NSString stringWithFormat:@"logistics.do?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking postWithUrl:path refreshCache:YES emphasis:NO params:nil success:^(id response) {
        [HYBNetworking response:response success:^(id result, NSString *success_msg) {
            
            [Tools saveObject:result forKey:SaveData_LogisticsCompany];
            
        } fail:^(NSString *error_msg) {
            
        }];
    } fail:^(NSError *error) {
    }];
    
}

//获取公告图片
-(void)loadBanner{
    NSMutableArray *pictureUrlArray = [[NSMutableArray alloc]init];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:TokenData],     @"token",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"index.php/Api/Ad/show?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        //        NSString *token = [[dic valueForKey:@"data"]valueForKey:@"token"];
        for (NSDictionary *temDic in [dic valueForKey:@"data"]) {
            NSString *pictureUrl = [dic valueForKey:@"image"];
            [pictureUrlArray addObject:pictureUrl];
        }
        NSLog(@"pictureUrlArray:%@",pictureUrlArray);
        
        
        
    } fail:^(NSError *error) {
        
    }];
}

@end