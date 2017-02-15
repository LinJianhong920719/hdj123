//
//  AppConfig.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "Tools.h"
#import "UIFont.h"
#import "GlobalDefine.h"
#import "Analytics.h"


#define ENVIRONMENT 0     // 环境 0.测试 1.正式
#define VERSION     @"2.3"// 接口版本

#if                 ENVIRONMENT
#define SERVICE_URL @"http://b2c.taozhuma.com/v"VERSION"/"
#define WEB_URL     @"http://b2c.taozhuma.com/"
#else
//#define SERVICE_URL @"http://testb2c.taozhuma.com/v"VERSION"/"
#define SERVICE_URL @"http://www.ihaodangjia.com/"
#define WEB_URL     @"http://testb2c.taozhuma.com/"

//============================ token信息 ==========================//
#define TokenDatas @"Token_datas"

//=====================用户信息======================//
//用户id
#define KEY_USER_ID @"key_user_id"
//用户昵称
#define KEY_USER_NAME @"key_user_name"
//用户手机号码
#define KEY_USER_PHONE @"key_user_phone"
//用户头像
#define KEY_USER_IMAGE @"key_user_image"
//用户手机号码
#define KEY_USER_PHONE @"key_user_phone"

#define KEY_IS_LOGIN @"key_is_login"

//当前纬度
#define CURRENT_LATITUDE @"current_latitude"
//当前经度
#define CURRENT_LONGITUDE @"current_longitude"
//当前城市
#define CURRENT_CITY_NAME @"current_city"
//当前区县
#define CURRENT_DISTRICT_NAME @"current_district"
//当前街道
#define CURRENT_STREET_NAME @"current_street"
//小区ID
#define COMMUNITYID @"communityid"
//小区名称
#define COMMUNITYNAME @"communityName"

//手动定位纬度
#define CUSTOM_LATITUDE @"custom_latitude"
//手动定位经度
#define CUSTOM_LONGITUDE @"custom_longitude"
//手动定位城市
#define CUSTOM_CITY_NAME @"custom_city"
//定位搜索记录
#define CUSTOM_RECORD @"custom_record"
#endif


//==============================   友盟   ==================================//

#define UmengAppkey            @"57c680b467e58eda8e00303c"        // 友盟 AppKey

#define UMENG_CHANNEL_ID       @"App Store"                       // 友盟渠道 其他渠道@"umeng_channel_01"

#define WXAppId                @"wx88fa4c9662539a8f"              // 微信 AppId
#define WXAppSecret            @"bf5cb0a3b32076886049d61eac6cfe06"// 微信 Appsecret
#define SinaAppKey             @"655720738"                       // 新浪 AppKey
#define SinaAppSecret          @"3ff4e846e0d5b2324ae6de160a64c014"// 新浪 AppSecret


//==========================   TalkingData   ==============================//

#define TalkingData_Appkey     @"277FF417830E8317DDC1EF16386889B0" // TalkingData AppKey

#define TALKINGDATA_CHANNEL_ID @"App Store" // TalkingData渠道 其他渠道@"umeng_channel_01"



//==============================   融云   ==================================//

//开发环境
//#define RCIM_APP_KEY                @"0vnjpoadn5z8z"        //App Key
//#define RCIM_CS_ID                  @"KEFU145776931841628"  //客服Id

//正式环境
#define RCIM_APP_KEY                @"e5t4ouvptxjga"        //App Key
#define RCIM_CS_ID                  @"KEFU145776932169996"  //客服ID
#define RCIM_CS_MQID                @"taozhuma"             //美洽公众号ID

#define RCIM_USER_TOKEN             @"rcim_user_token"      //融云客户端请求 Token

#define KEY_IS_LOGIN_RCIM           @"is_login_rcimclient"  //是否登录融云

#define AppIconBadgeNumber          [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_APPSERVICE)]] //融云未读消息数
#define ResetMessageCount_RCIM      @"resetTheMessageCount_RCIM" //重置未读消息数通知
//==============================   设备信息   ==================================//
#define DEVICE_SCREEN_SIZE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_SCREEN_SIZE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DEVICE_SCREEN_ORIGIN_X [[UIScreen mainScreen] bounds].origin.x
#define DEVICE_SCREEN_ORIGIN_Y [[UIScreen mainScreen] bounds].origin.y


//==============================颜色==================================//
#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define LINECOLOR_DEFAULT UIColorWithRGBA(220, 220, 220, 1)
#define BGCOLOR_DEFAULT UIColorWithRGBA(245, 245, 245, 1)
#define THEME_COLORS UIColorWithRGBA(254, 61, 189, 1)
#define PRODUCT_COLOR UIColorWithRGBA(254, 61, 189, 1)
#define LINECOLOR_DEFAULT UIColorWithRGBA(220, 220, 220, 1)
#define BACK_DEFAULT UIColorWithRGBA(255, 214, 0, 1)
#define THEME_COLORS_RED UIColorWithRGBA(230, 29, 88, 1)
#define FONT_COLOR UIColorWithRGBA(38, 38, 38, 1)
#define FONTS_COLOR51 UIColorWithRGBA(51, 51, 51, 1)
#define FONTS_COLOR102 UIColorWithRGBA(102, 102, 102, 1)
#define FONTS_COLOR153 UIColorWithRGBA(153, 153, 153, 1)
#define THEME_COLORS_Oring UIColorWithRGBA(255, 80, 0, 1)


#define COLOR_717071 UIColorWithRGBA(71, 70, 71, 1)
#define COLOR_666464 UIColorWithRGBA(102, 100, 100, 1)
#define COLOR_898989 UIColorWithRGBA(137, 137, 137, 1)
#define COLOR_eeefef UIColorWithRGBA(238, 239, 239, 1)
#define COLOR_3e3a39 UIColorWithRGBA(62, 58, 57, 1)


/*======================= 接口 =======================*/


#define ADVERTISEMENTPOINT @"ad.php?"                   //广告接口

#define contentInsetY 32
#define tableViewFrame      CGRectMake(0, ViewOrignY, DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY-50-contentInsetY)

/*======================= SIZE =======================*/
#define PROPORTION                  (DEVICE_SCREEN_SIZE_WIDTH/320.0f)
#define PROPORTION414               (DEVICE_SCREEN_SIZE_WIDTH/414.0f)
@interface AppConfig : NSObject
/*======================= 用户充值标示 =======================*/
#define KEY_RECHARGE_TAG @"key_recharge_tag"
@end
