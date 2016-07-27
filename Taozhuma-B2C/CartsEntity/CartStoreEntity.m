//
//  CartB2CEntity.m
//  b2c购物车Entity
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "CartStoreEntity.h"

@implementation CartStoreEntity

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.carts = [attributes valueForKey:@"carts"];
    self.shopName = [attributes valueForKey:@"shopName"];
    self.shopId = [attributes valueForKey:@"shopId"];
    self.discountType = [[attributes valueForKey:@"discountType"]integerValue];
    self.discountArray = [attributes valueForKey:@"discountText"];

    return self;
}

@end
