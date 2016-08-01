//
//  Tools.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (Tools *)sharedInstance {
    static Tools *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Tools alloc] init];
    });
    return sharedInstance;
}

+ (void) saveBool:(BOOL)boolValue forKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:boolValue forKey:key];
}

+ (BOOL) boolForKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:key];
}

+ (void) saveObject:(id)objectValue forKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:objectValue forKey:key];
}

+ (id) objectForKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

+ (NSString *) stringForKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault stringForKey:key];
}

+ (NSArray *) arrayForKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault arrayForKey:key];
}

+ (void) saveInteger:(NSInteger)intValue forKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:intValue forKey:key];
}

+ (NSInteger)intForKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault integerForKey:key];
}

+ (void) saveDouble:(float)doubleValue forKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setDouble:doubleValue forKey:key];
}

+ (float)doubleForKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault doubleForKey:key];
}

+ (void) saveFloat:(float)floatValue forKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setFloat:floatValue forKey:key];
}

+ (float)floatForKey:(NSString *)key {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault floatForKey:key];
}

+ (void)clearCaches {
    // 清除接口缓存数据
    [HYBNetworking clearCaches];
    // 清除图片缓存
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    // 清除系统缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
/*
 手机号码验证 MODIFIED BY HELENSONG
 */
+ (BOOL) isValidateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

@end
