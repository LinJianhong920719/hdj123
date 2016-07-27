//
//  Analytics.m
//  Taozhuma-B2C
//
//  Created by yusaiyan on 16/5/11.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "Analytics.h"

@implementation Analytics

+ (void)event:(NSString *)eventId {
    
    [MobClick event:eventId];
    
    [TalkingData trackEvent:eventId];
    
}

+ (void)event:(NSString *)eventId label:(NSString *)label parameters:(NSDictionary *)parameters {
    
    [MobClick event:eventId attributes:parameters];
    
    [TalkingData trackEvent:eventId label:label parameters:parameters];
}

+ (void)beginLogPageView:(NSString *)pageName {
    
    [MobClick beginLogPageView:pageName];
    
    [TalkingData trackPageBegin:pageName];
    
}

+ (void)endLogPageView:(NSString *)pageName {
    
    [MobClick endLogPageView:pageName];
    
    [TalkingData trackPageEnd:pageName];
    
}

@end
