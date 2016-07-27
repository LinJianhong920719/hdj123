//
//  Analytics.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/11.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClick.h"
#import "TalkingData.h"

@interface Analytics : NSObject

/**
 *	@method	event
 *  统计自定义事件
 *
 *	@param 	eventId 	事件名称（自定义）
 */
+ (void)event:(NSString *)eventId;

/**
 *	@method	trackEvent:label:parameters
 *  统计带二级参数的自定义事件，单次调用的参数数量不能超过10个
 *
 *	@param 	eventId 	事件名称（自定义）
 *	@param 	eventLabel 	事件标签（自定义）
 *	@param 	parameters 	事件参数 (key只支持NSString, value支持NSString和NSNumber)
 */+ (void)event:(NSString *)eventId label:(NSString *)label parameters:(NSDictionary *)parameters;

/**
 *	@method	beginLogPageView
 *  开始跟踪某一页面（可选），记录页面打开时间
 *  建议在viewWillAppear或者viewDidAppear方法里调用
 *
 *	@param 	pageName 	页面名称（自定义）
 */
+ (void)beginLogPageView:(NSString *)pageName;

/**
 *	@method	endLogPageView
 *  结束某一页面的跟踪（可选），记录页面的关闭时间
 *  此方法与trackPageBegin方法结对使用，
 *  在iOS应用中建议在viewWillDisappear或者viewDidDisappear方法里调用
 *  在Watch应用中建议在DidDeactivate方法里调用
 *
 *	@param 	pageName 	页面名称，请跟trackPageBegin方法的页面名称保持一致
 */
+ (void)endLogPageView:(NSString *)pageName;

@end
