//
//  CartB2CEntity.h
//  b2c购物车Entity
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartProductEntity : NSObject

@property (nonatomic, strong) NSString *cid; //商品数据库id
@property (nonatomic, strong) NSString *image; //图片
@property (nonatomic, strong) NSString *name; //名称
@property (nonatomic, strong) NSString *number; //数量
@property (nonatomic, strong) NSString *price; //单价
@property (nonatomic, strong) NSString *productId; //商品ID
@property (nonatomic, strong) NSString *shopId; //商家ID
@property (nonatomic, strong) NSString *shopName; //商家名称
@property (nonatomic, strong) NSString *status; //是否下架
@property (nonatomic, strong) NSString *chooseTag; //勾选状态
@property (nonatomic, strong) NSString *inventory; //库存量
@property (nonatomic, strong) NSString *subtotal; //价格小计
@property (nonatomic, strong) NSString *skuLinkId; //规格id
@property (nonatomic, strong) NSString *skuValue; //规格名称
@property (nonatomic, strong) NSString *isActive; //是否活动
@property (nonatomic, strong) NSString *activityId; //活动id
@property (nonatomic, strong) NSString *type; //活动类型
@property (nonatomic, assign) NSString *preferential;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
