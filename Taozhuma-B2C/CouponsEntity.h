//
//  CouponsEntity.h
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponsEntity : NSObject

@property (nonatomic, strong) NSString *couponsID;//优惠卷id
@property (nonatomic, strong) NSString *uID;//优惠卷id
@property (nonatomic, strong) NSString *activationCode;//激活码
@property (nonatomic, strong) NSString *expValue;//面值
@property (nonatomic, strong) NSString *startTime;//可以使用开始时间
@property (nonatomic, strong) NSString *endTime;//失效时间
@property (nonatomic, strong) NSString *status;//状态0未激活1未使用2已使用
@property (nonatomic, strong) NSString *addTime;//生成时间
@property (nonatomic, strong) NSString *useTime;//使用时间
@property (nonatomic, strong) NSString *type;//类型 0直减1满50 2满100
@property (nonatomic, strong) NSString *timeLength;//有效时长


- (id)initWithAttributes:(NSDictionary *)attributes;

@end
