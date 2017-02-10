//
//  OrderDetailEntity.h
//  Taozhuma-B2C
//
//  Created by edz on 17/2/10.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailEntity : NSObject


@property (nonatomic, strong) NSString* goodId; //商品id
@property (nonatomic, strong) NSString* goodImage;//商品图片
@property (nonatomic, strong) NSString* goodName;//商品名称
@property (nonatomic, strong) NSString* goodPrice;//商品价格
@property (nonatomic, strong) NSString* goodSize;//商品规格
@property (nonatomic, strong) NSString* nums;//商品数量

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
