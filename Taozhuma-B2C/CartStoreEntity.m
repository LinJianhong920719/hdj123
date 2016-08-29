//
//  CartStoreEntity.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "CartStoreEntity.h"

@implementation CartStoreEntity

@synthesize carts;
@synthesize shopName;
@synthesize shopId;
@synthesize chooseTag;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    carts = [attributes valueForKey:@"goodsList"];
    shopName = [attributes valueForKey:@"sj_shop_name"];
    shopId = [attributes valueForKey:@"shop_id"];
    chooseTag = @"0";
    return self;
}

@end
