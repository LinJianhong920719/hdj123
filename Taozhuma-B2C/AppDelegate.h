//
//  AppDelegate.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/5.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate,BMKLocationServiceDelegate>{
    BMKLocationService* _locService;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) BMKMapManager* mapManager;
@property (nonatomic, assign) BOOL isStop;

+ (AppDelegate *)sharedAppDelegate;
//获取Token信息
-(void)getTokenMessage;
@end

