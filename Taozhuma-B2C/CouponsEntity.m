//
//  CouponsEntity.m
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import "CouponsEntity.h"

@implementation CouponsEntity
@synthesize couponsID;//优惠卷id
@synthesize uID;//优惠卷id
@synthesize activationCode;//激活码
@synthesize expValue;//面值
@synthesize startTime;//可以使用开始时间
@synthesize endTime;//失效时间
@synthesize status;//状态0未激活1未使用2已使用
@synthesize addTime;//生成时间
@synthesize useTime;//使用时间
@synthesize type;//类型 0直减1满50 2满100
@synthesize timeLength;//有效时长

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    couponsID = [attributes valueForKey:@"id"];
    uID = [attributes valueForKey:@"user_id"];
    activationCode = [attributes valueForKey:@"card_number"];
    expValue = [attributes valueForKey:@"exp_value"];
    startTime = [attributes valueForKey:@"start_time"];
    endTime = [attributes valueForKey:@"end_time"];
    status = [attributes valueForKey:@"status"];
    addTime = [attributes valueForKey:@"add_time"];
    useTime = [attributes valueForKey:@"use_time"];
    type = [attributes valueForKey:@"type"];
    timeLength = [attributes valueForKey:@"time_length"];


    return self;
}

@end
