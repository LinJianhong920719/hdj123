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
#import "UMSocialQQHandler.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <UserNotifications/UserNotifications.h>
#import <MeiQiaSDK/MQManager.h>
#import "MQServiceToViewInterface.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000

@interface AppDelegate ()

@property (nonatomic, strong) JTBaseNavigationController *mainNavigationController;
@property (nonatomic, strong) UITabBarController *mainTabBarController;

@end

BMKMapManager* _mapManager;
@implementation AppDelegate
@synthesize isStop;

+ (AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    isStop = false;
    //程序开启时将用户充值标示设置为false，用以区分用户充值跟订单支付的函数回调
    [Tools saveBool:false forKey:KEY_RECHARGE_TAG];
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"dekD1hGpYbhaTFsj30yIyaFQ34nDLc0E" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //百度定位
    [self initBDLocationManager];
    
    //微信支付
    [WXApi registerApp:@"wx69b0d0dbc086b71f"];
    
    //友盟分享
    [self umeng_share];
    
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
    //[self guideManager];
    
    // 友盟分析
    //[self umeng_Analytics];
    // 友盟推送
   // [self umeng_Message:launchOptions];
    //阿里云推送
    
    [self initCloudPush];
    [CloudPushSDK handleLaunching:launchOptions];
    
    [self registerAPNS:application];
    [self registerMessageReceive];
    // 友盟第三方登录
    //[self umeng_LoginQuick];
    
    // 配置网络访问参数
    [self configNetworking];
    //网络状态监控
    [self networkChanged];
    
    //美洽
    [self MQManagerInit:@"2664720be18d7fa45b7d53b3f3a82b65"];
    
    


    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, global_quque, ^{
        // 获取分类数据
        //[self loadClassificationData];
    });
    
    dispatch_group_async(group, global_quque, ^{
        // 获取物流公司数据
        //[self loadLogisticsCompanyData];
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
    //App 进入后台时，关闭美洽服务
    [MQManager closeMeiqiaService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //App 进入前台时，开启美洽服务
    [MQManager openMeiqiaService];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [UMessage registerDeviceToken:deviceToken];
//    
//    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
//
//    [Tools saveObject:token forKey:DeviceToken];
    
    NSLog(@"sss:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    NSLog(@"deviceToken:%@",deviceToken);
    //苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [UMessage didReceiveRemoteNotification:userInfo];
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
//    [CloudPushSDK handleLaunching:userInfo];
    [CloudPushSDK handleReceiveRemoteNotification:userInfo];
}

// ----------------------------------------------------------------------------------------
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
// ----------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
// ----------------------------------------------------------------------------------------
// iOS10新增：处理前台收到通知的代理方法
// ----------------------------------------------------------------------------------------
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    } else {
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

// ----------------------------------------------------------------------------------------
// iOS10新增：处理后台点击通知的代理方法
// ----------------------------------------------------------------------------------------
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    } else {
        //应用处于后台时的本地推送接受
    }
    
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

#pragma mark(友盟分享)
-(void)umeng_share{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx69b0d0dbc086b71f" appSecret:@"a28601a4fa989fe6e2efc19c25dad50f" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
//                                              secret:@"04b48b094faeb16683c32669824ebdad"
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

#pragma mark (友盟回调)
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            NSString *payStatus = [resultDic valueForKey:@"resultStatus"];
            NSLog(@"resultStatus:%@",[resultDic valueForKey:@"resultStatus"]);
            //订单调用支付宝支付成功情况回调
            if ([payStatus intValue] == 9000 && ![Tools stringForKey:KEY_RECHARGE_TAG]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"alipaySuccess" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refCart" object:nil];
            }else if ([payStatus intValue] == 9000 && [Tools stringForKey:KEY_RECHARGE_TAG]){
                //用户充值成功情况回调
                [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeSuccess" object:nil];
            }else{
                //订单调用支付宝支付成功情况回调
                if (![Tools stringForKey:KEY_RECHARGE_TAG]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayFail" object:@"1"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refCart" object:nil];
                }else{
                    //用户充值成功情况回调
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeFail" object:nil];
                }
                
            }
            
        }];
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
    
}
/*微信支付回调*/
- (void)onResp:(BaseResp *)resp
{
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    switch (resp.errCode) {
        case WXSuccess:
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            if ([Tools stringForKey:KEY_RECHARGE_TAG]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeSuccess" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"alipaySuccess" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refCart" object:nil];
            }
            break;
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            if ([Tools stringForKey:KEY_RECHARGE_TAG]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeFail" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayFail" object:@"2"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refCart" object:nil];
            }
            break;
    }
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

//获取首页地址信息
- (void)loadIndexAddressMsg {
    NSString *longitude;
    NSString *latitude;
    if([Tools stringForKey:CURRENT_LONGITUDE] == NULL){
        longitude = @"116.7634506225586";
    }else{
        longitude = [Tools stringForKey:CURRENT_LONGITUDE];
    }
    if ([Tools stringForKey:CURRENT_LATITUDE] == NULL) {
        latitude = @"116.7634506225586";
    }else{
        latitude = [Tools stringForKey:CURRENT_LATITUDE];
    }
    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [Tools stringForKey:CURRENT_LONGITUDE],  @"longitude",
                          [Tools stringForKey:CURRENT_LATITUDE],   @"latitude",
                          nil];
    
    NSString *xpoint = @"/Api/Community/show?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        if([statusMsg intValue] == 200){
            
            
            NSArray *data = [dic valueForKey:@"data"];
            [Tools saveObject:[data[0] valueForKey:@"com_name"] forKey:COMMUNITYNAME];
            [Tools saveObject:[data[0] valueForKey:@"id"] forKey:COMMUNITYID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refAddress" object:nil];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
- (void)MQManagerInit:(NSString *)MQAppkey{
    [MQManager initWithAppkey:MQAppkey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
        }
        
        [MQServiceToViewInterface getUnreadMessagesWithCompletion:^(NSArray *messages, NSError *error) {
            NSLog(@">> unread message count: %d", (int)messages.count);
        }];
    }];
}


//获取Token信息
-(void)getTokenMessage{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         @"hdjApp",     @"appid",
                         @"HaoDangJia",@"appsecret",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"index.php/Api/index/getToken?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *token = [[dic valueForKey:@"data"]valueForKey:@"token"];
        NSLog(@"token:%@",token);
       [Tools saveObject:token forKey:TokenDatas];
        //通知 发出
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenMessage" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadTableMsg" object:nil];
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - 百度定位

// ----------------------------------------------------------------------------------------
// 初始化 BMKLocationService
// ----------------------------------------------------------------------------------------
- (void)initBDLocationManager {
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //设置距离过滤器(默认距离是米)
    _locService.distanceFilter = 300.0f;
    //设置定位精度
//    _locService.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    //启动LocationService
    [_locService startUserLocationService];
    
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"方向: %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    if (isStop == false) {
        if (userLocation.location != nil) {
            [Tools saveDouble:userLocation.location.coordinate.latitude forKey:CURRENT_LATITUDE];
            [Tools saveDouble:userLocation.location.coordinate.longitude forKey:CURRENT_LONGITUDE];
            NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
            [_locService stopUserLocationService];
            [self loadIndexAddressMsg];
//            //通知 发出
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refAddressMessage" object:nil];
//        }
//        isStop = true;
    }
    
    
}

#pragma mark 联网相关方法
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


#pragma mark - 阿里云SDK初始化
- (void)initCloudPush {
    // SDK初始化
    [CloudPushSDK asyncInit:@"23440826" appSecret:@"9b63e63786ebe8e51de391c74032ae11" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}
/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}
/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}

@end
