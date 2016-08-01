//
//  Tools.h
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"
#import "UserDefaultsKey.h"
#import "UIImageView+WebCache.h"
#import "HYBNetworking.h"

//宏定义全局并发队列
#define global_quque    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//宏定义主队列
#define main_queue       dispatch_get_main_queue()

@interface Tools : NSObject

+ (Tools *)sharedInstance;

+ (void) saveBool:(BOOL)boolValue forKey:(NSString *)key;
+ (BOOL) boolForKey:(NSString *)key;

+ (void) saveObject:(id)objectValue forKey:(NSString *)key;
+ (id) objectForKey:(NSString *)key;
+ (NSString *) stringForKey:(NSString *)key;
+ (NSArray *) arrayForKey:(NSString *)key;

+ (void) saveInteger:(NSInteger)intValue forKey:(NSString *)key;
+ (NSInteger)intForKey:(NSString *)key;

+ (void) saveDouble:(float)doubleValue forKey:(NSString *)key;
+ (float)doubleForKey:(NSString *)key;

+ (void) saveFloat:(float)floatValue forKey:(NSString *)key;
+ (float)floatForKey:(NSString *)key;

/*＊
 手机号码验证 MODIFIED BY HELENSONG
 */
+ (BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  清除缓存
 */
+ (void)clearCaches;

@end
